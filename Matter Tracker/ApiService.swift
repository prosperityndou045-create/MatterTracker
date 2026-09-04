//
//  ApiService.swift
//  Matter Tracker
//
//  Created by Prosperity on 4/9/2026.
//

import Foundation

enum APIConfig {
    static let baseURL = URL(string: "https://skills-tracker-api.nashdigitechsolutions.workers.dev")!
}

struct APIEnvelope<T: Decodable>: Decodable {
    let success: Bool
    let data: T
}

struct APIErrorEnvelope: Decodable {
    let success: Bool
    let error: APIErrorBody
}

struct APIErrorBody: Decodable {
    let message: String
    let details: AnyDecodableValue?
}

struct AnyDecodableValue: Decodable {
    let value: Any?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let v = try? container.decode(String.self) { value = v; return }
        if let v = try? container.decode(Double.self) { value = v; return }
        if let v = try? container.decode(Bool.self) { value = v; return }
        if let v = try? container.decode([String: AnyDecodableValue].self) {
            value = v.mapValues { $0.value as Any }; return
        }
        if let v = try? container.decode([AnyDecodableValue].self) {
            value = v.map { $0.value as Any }; return
        }
        value = nil
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case noToken
    case unauthorized
    case validation(fieldErrors: [String: [String]], formErrors: [String])
    case decoding(Error)
    case server(status: Int, message: String, details: AnyDecodableValue?)
    case transport(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noToken: return "You're not signed in."
        case .unauthorized: return "Your session has expired. Please sign in again."
        case .validation: return "Please fix the highlighted fields."
        case .decoding(let e): return "Couldn't read the server's response: \(e.localizedDescription)"
        case .server(let status, let message, _): return "\(message) (\(status))"
        case .transport(let e): return e.localizedDescription
        }
    }
}

extension Notification.Name {
    static let apiServiceDidReceiveUnauthorized = Notification.Name("apiServiceDidReceiveUnauthorized")
}

private struct ZodFlattenDetails: Decodable {
    let fieldErrors: [String: [String]]?
    let formErrors: [String]?
}

private struct APIErrorEnvelope422: Decodable {
    let success: Bool
    let error: Error422Body
}

private struct Error422Body: Decodable {
    let message: String
    let details: ZodFlattenDetails?
}

enum UserRole: String, Codable, CaseIterable {
    case student, facilitator, manager, external_reviewer
}

enum SkillCategory: String, Codable {
    case technical, essential
}

enum SkillStatus: String, Codable {
    case not_started, in_progress, pending_review, demonstrated, needs_more_evidence
}

enum EvidenceType: String, Codable, CaseIterable {
    case ltc_challenge, code_sample, github_repository, video, project, assessment,
         facilitator_feedback, essential_skill_demo, other
}

enum EvidenceStatus: String, Codable {
    case pending_review, approved, rejected, more_evidence_needed
}

enum ReviewDecision: String, Codable, CaseIterable {
    case approve, reject, more_evidence
}

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let role: UserRole
    let firstName: String
    let lastName: String
    let bio: String?
    let profilePictureUrl: String?
    let cohortId: String?
    let facilitatorId: String?
    let isActive: Bool?
    let createdAt: Date?
    let updatedAt: Date?
}

struct AuthResponse: Codable {
    let user: User
    let token: String
}

struct Cohort: Codable, Identifiable {
    let id: String
    let name: String
    let startDate: Date?
    let endDate: Date?
    let createdAt: Date?
}

struct CohortDetail: Codable, Identifiable {
    let id: String
    let name: String
    let startDate: Date?
    let endDate: Date?
    let students: [User]?
}

struct Skill: Codable, Identifiable {
    let id: String
    let name: String
    let category: SkillCategory
    let description: String?
}

struct StudentSkill: Codable, Identifiable {
    let id: String
    let studentId: String
    let skillId: String
    let status: SkillStatus
    let updatedAt: Date?
    let skill: Skill?
}

struct Evidence: Codable, Identifiable {
    let id: String
    let studentId: String
    let skillId: String
    let type: EvidenceType
    let title: String
    let description: String?
    let attachmentUrl: String?
    let githubUrl: String?
    let videoUrl: String?
    let status: EvidenceStatus
    let reviewerId: String?
    let feedback: String?
    let submittedAt: Date?
    let reviewedAt: Date?
    let externalReviews: [ExternalReview]?
}

struct ExternalReview: Codable, Identifiable {
    let id: String
    let evidenceId: String
    let externalReviewerId: String
    let feedback: String
    let submittedAt: Date?
}

struct Project: Codable, Identifiable {
    let id: String
    let studentId: String
    let name: String
    let description: String?
    let url: String?
    let createdAt: Date?
}

struct Achievement: Codable, Identifiable {
    let id: String
    let studentId: String
    let title: String
    let description: String?
    let dateAwarded: Date?
}

struct Portfolio: Codable {
    let studentId: String?
    let demonstratedSkills: [StudentSkill]?
    let approvedEvidence: [Evidence]?
    let projects: [Project]?
    let achievements: [Achievement]?
}

struct ShareLink: Codable {
    let shareToken: String
    let shareUrl: String?
    let expiresAt: Date?
}

struct ExternalAccessGrant: Codable {
    let studentId: String
    let externalReviewerId: String
}

struct CohortAnalytics: Codable {
    let cohortId: String
    let totalStudents: Int
    let mostDemonstrated: [SkillStat]
    let skillGaps: [SkillStat]
    let evidencePending: Int
}

struct SkillStat: Codable, Identifiable {
    let skillId: String
    let name: String
    let percentDemonstrated: Double
    var id: String { skillId }
}

struct PublicCandidate: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let bio: String?
    let profilePictureUrl: String?
    let demonstratedSkills: [StudentSkill]?
    let approvedEvidence: [Evidence]?
    let projects: [Project]?
    let achievements: [Achievement]?
}

final class TokenStore {
    static let shared = TokenStore()
    private let key = "com.mattertracker.jwt"

    private init() {}

    private(set) var token: String? {
        get { KeychainHelper.read(key: key) }
        set {
            if let newValue {
                KeychainHelper.save(key: key, value: newValue)
            } else {
                KeychainHelper.delete(key: key)
            }
        }
    }

    func save(_ token: String) { self.token = token }
    func clear() { self.token = nil }
    func current() -> String? { token }
}

enum KeychainHelper {
    static func save(key: String, value: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
        var attributes = query
        attributes[kSecValueData as String] = data
        SecItemAdd(attributes as CFDictionary, nil)
    }

    static func read(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}

actor ApiService {
    static let shared = ApiService()

    private let session: URLSession
    private let baseURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    private init(baseURL: URL = APIConfig.baseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    private enum HTTPMethod: String { case GET, POST, PATCH, DELETE }

    private func request<Response: Decodable>(
        _ method: HTTPMethod,
        _ path: String,
        query: [String: String]? = nil,
        body: Encodable? = nil,
        auth: Bool = true
    ) async throws -> Response {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        if let query {
            components?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components?.url else { throw APIError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if auth {
            guard let token = TokenStore.shared.current() else { throw APIError.noToken }
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            req.httpBody = try encoder.encode(AnyEncodable(body))
        }

        let (data, response) = try await performData(req)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0

        guard (200..<300).contains(status) else {
            if status == 401 {
                TokenStore.shared.clear()
                NotificationCenter.default.post(name: .apiServiceDidReceiveUnauthorized, object: nil)
                throw APIError.unauthorized
            }

            let errEnvelope = try? decoder.decode(APIErrorEnvelope.self, from: data)

            if status == 422, let detailsPayload = try? JSONDecoder().decode(APIErrorEnvelope422.self, from: data) {
                throw APIError.validation(
                    fieldErrors: detailsPayload.error.details?.fieldErrors ?? [:],
                    formErrors: detailsPayload.error.details?.formErrors ?? []
                )
            }

            if let errEnvelope {
                throw APIError.server(status: status, message: errEnvelope.error.message, details: errEnvelope.error.details)
            }
            throw APIError.server(status: status, message: "Request failed", details: nil)
        }

        do {
            let envelope = try decoder.decode(APIEnvelope<Response>.self, from: data)
            return envelope.data
        } catch {
            throw APIError.decoding(error)
        }
    }

    private func requestVoid(
        _ method: HTTPMethod,
        _ path: String,
        query: [String: String]? = nil,
        body: Encodable? = nil,
        auth: Bool = true
    ) async throws {
        let _: EmptyResponse = try await request(method, path, query: query, body: body, auth: auth)
    }

    private func performData(_ req: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: req)
        } catch {
            throw APIError.transport(error)
        }
    }

    // MARK: - Auth

    struct RegisterBody: Encodable {
        let email: String
        let password: String
        let firstName: String
        let lastName: String
        let cohortId: String?
        let bio: String?
    }

    func register(email: String, password: String, firstName: String, lastName: String,
                  cohortId: String? = nil, bio: String? = nil) async throws -> AuthResponse {
        let body = RegisterBody(email: email, password: password, firstName: firstName,
                                 lastName: lastName, cohortId: cohortId, bio: bio)
        let auth: AuthResponse = try await request(.POST, "/auth/register", body: body, auth: false)
        TokenStore.shared.save(auth.token)
        return auth
    }

    struct LoginBody: Encodable { let email: String; let password: String }

    func login(email: String, password: String) async throws -> AuthResponse {
        let body = LoginBody(email: email, password: password)
        let auth: AuthResponse = try await request(.POST, "/auth/login", body: body, auth: false)
        TokenStore.shared.save(auth.token)
        return auth
    }

    func me() async throws -> User {
        try await request(.GET, "/auth/me")
    }

    func logout() {
        TokenStore.shared.clear()
    }

    // MARK: - Users

    func listUsers(role: UserRole? = nil, cohortId: String? = nil) async throws -> [User] {
        var query: [String: String] = [:]
        if let role { query["role"] = role.rawValue }
        if let cohortId { query["cohortId"] = cohortId }
        return try await request(.GET, "/users", query: query.isEmpty ? nil : query)
    }

    struct ProvisionUserBody: Encodable {
        let email: String
        let password: String
        let role: UserRole
        let firstName: String
        let lastName: String
    }

    func provisionUser(_ body: ProvisionUserBody) async throws -> User {
        try await request(.POST, "/users", body: body)
    }

    func getUser(id: String) async throws -> User {
        try await request(.GET, "/users/\(id)")
    }

    struct UpdateUserBody: Encodable {
        let firstName: String?
        let lastName: String?
        let bio: String?
        let profilePictureUrl: String?
        let cohortId: String?
        let facilitatorId: String?
    }

    func updateUser(id: String, _ body: UpdateUserBody) async throws -> User {
        try await request(.PATCH, "/users/\(id)", body: body)
    }

    // MARK: - Cohorts

    func listCohorts() async throws -> [Cohort] {
        try await request(.GET, "/cohorts")
    }

    func getCohort(id: String) async throws -> CohortDetail {
        try await request(.GET, "/cohorts/\(id)")
    }

    struct CreateCohortBody: Encodable {
        let name: String
        let startDate: String?
        let endDate: String?
    }

    func createCohort(_ body: CreateCohortBody) async throws -> Cohort {
        try await request(.POST, "/cohorts", body: body)
    }

    // MARK: - Skills Catalog

    func listSkills(category: SkillCategory? = nil) async throws -> [Skill] {
        try await request(.GET, "/skills", query: category.map { ["category": $0.rawValue] })
    }

    func getSkill(id: String) async throws -> Skill {
        try await request(.GET, "/skills/\(id)")
    }

    struct CreateSkillBody: Encodable {
        let name: String
        let category: SkillCategory
        let description: String?
    }

    func createSkill(_ body: CreateSkillBody) async throws -> Skill {
        try await request(.POST, "/skills", body: body)
    }

    // MARK: - Student Workflow

    func studentSkills(studentId: String) async throws -> [StudentSkill] {
        try await request(.GET, "/students/\(studentId)/skills")
    }

    func studentSkill(studentId: String, skillId: String) async throws -> StudentSkill {
        try await request(.GET, "/students/\(studentId)/skills/\(skillId)")
    }

    func studentEvidence(studentId: String) async throws -> [Evidence] {
        try await request(.GET, "/students/\(studentId)/evidence")
    }

    struct SubmitEvidenceBody: Encodable {
        let skillId: String
        let type: EvidenceType
        let title: String
        let description: String?
        let attachmentUrl: String?
        let githubUrl: String?
        let videoUrl: String?
    }

    func submitEvidence(studentId: String, _ body: SubmitEvidenceBody) async throws -> Evidence {
        try await request(.POST, "/students/\(studentId)/evidence", body: body)
    }

    func studentProjects(studentId: String) async throws -> [Project] {
        try await request(.GET, "/students/\(studentId)/projects")
    }

    struct CreateProjectBody: Encodable {
        let name: String
        let description: String?
        let url: String?
    }

    func addProject(studentId: String, _ body: CreateProjectBody) async throws -> Project {
        try await request(.POST, "/students/\(studentId)/projects", body: body)
    }

    func studentAchievements(studentId: String) async throws -> [Achievement] {
        try await request(.GET, "/students/\(studentId)/achievements")
    }

    struct CreateAchievementBody: Encodable {
        let title: String
        let description: String?
        let dateAwarded: String?
    }

    func addAchievement(studentId: String, _ body: CreateAchievementBody) async throws -> Achievement {
        try await request(.POST, "/students/\(studentId)/achievements", body: body)
    }

    func studentPortfolio(studentId: String) async throws -> Portfolio {
        try await request(.GET, "/students/\(studentId)/portfolio")
    }

    func sharePortfolio(studentId: String, expiresInDays: Int? = nil) async throws -> ShareLink {
        struct Body: Encodable { let expiresInDays: Int? }
        return try await request(.POST, "/students/\(studentId)/portfolio/share", body: Body(expiresInDays: expiresInDays))
    }

    // MARK: - Evidence Review

    func getEvidence(id: String) async throws -> Evidence {
        try await request(.GET, "/evidence/\(id)")
    }

    struct ReviewEvidenceBody: Encodable {
        let decision: ReviewDecision
        let feedback: String?
    }

    func reviewEvidence(id: String, decision: ReviewDecision, feedback: String? = nil) async throws -> Evidence {
        let body = ReviewEvidenceBody(decision: decision, feedback: feedback)
        return try await request(.PATCH, "/evidence/\(id)/review", body: body)
    }

    // MARK: - Facilitator Dashboard

    func facilitatorStudents() async throws -> [User] {
        try await request(.GET, "/facilitator/students")
    }

    func facilitatorPendingReviews() async throws -> [Evidence] {
        try await request(.GET, "/facilitator/reviews/pending")
    }

    // MARK: - Manager Dashboard

    func managerCohortStudents(cohortId: String) async throws -> [User] {
        try await request(.GET, "/manager/cohorts/\(cohortId)/students")
    }

    func managerCohortAnalytics(cohortId: String) async throws -> CohortAnalytics {
        try await request(.GET, "/manager/cohorts/\(cohortId)/analytics")
    }

    func managerCohortPendingReviews(cohortId: String) async throws -> [Evidence] {
        try await request(.GET, "/manager/cohorts/\(cohortId)/pending-reviews")
    }

    func grantExternalAccess(studentId: String, externalReviewerId: String) async throws {
        let body = ExternalAccessGrant(studentId: studentId, externalReviewerId: externalReviewerId)
        try await requestVoid(.POST, "/manager/external-access", body: body)
    }

    // MARK: - External Reviewer Workflow

    func externalStudents() async throws -> [User] {
        try await request(.GET, "/external/students")
    }

    func externalStudentSkillsEvidence(studentId: String) async throws -> [Evidence] {
        try await request(.GET, "/external/students/\(studentId)/skills-evidence")
    }

    struct SubmitExternalReviewBody: Encodable {
        let evidenceId: String
        let feedback: String
    }

    func submitExternalReview(evidenceId: String, feedback: String) async throws -> ExternalReview {
        let body = SubmitExternalReviewBody(evidenceId: evidenceId, feedback: feedback)
        return try await request(.POST, "/external/reviews", body: body)
    }

    // MARK: - Public / Guest / Employer Workflow

    func publicCandidates(name: String? = nil, skill: String? = nil, cohortId: String? = nil) async throws -> [PublicCandidate] {
        var query: [String: String] = [:]
        if let name { query["name"] = name }
        if let skill { query["skill"] = skill }
        if let cohortId { query["cohortId"] = cohortId }
        return try await request(.GET, "/public/candidates", query: query.isEmpty ? nil : query, auth: false)
    }

    func publicCandidate(id: String) async throws -> PublicCandidate {
        try await request(.GET, "/public/candidates/\(id)", auth: false)
    }

    func publicProfile(shareToken: String) async throws -> PublicCandidate {
        try await request(.GET, "/public/profile/\(shareToken)", auth: false)
    }
}

private struct EmptyResponse: Decodable {}

private struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void

    init(_ wrapped: Encodable) {
        self.encodeFunc = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
