public struct FposCredential {
  public let idType: String
  public let fposId: String
  public let clientId: String?
  public let clientSecret: String?
  public let accessToken: String?

  public init(
    idType: String, fposId: String, clientId: String?, clientSecret: String?, accessToken: String?
  ) {
    self.idType = idType
    self.fposId = fposId
    self.clientId = clientId
    self.clientSecret = clientSecret
    self.accessToken = accessToken
  }
}
