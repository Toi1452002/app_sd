
// ignore_for_file: non_constant_identifier_names, constant_identifier_names
///Tạo table
const String T00_TuyChon = '''CREATE TABLE T00_TuyChon (
      Ma CHAR (5) PRIMARY KEY,
      GiaTri INT,
      MoTa VARCHAR)''';

const String T00_User = '''CREATE TABLE T00_User (
    ID INTEGER PRIMARY KEY ASC AUTOINCREMENT,
    MaKH,
    UserName VARCHAR UNIQUE NOT NULL,
    PassWord VARCHAR NOT NULL,
    MaKichHoat VARCHAR,
    NgayHetHan DATE    DEFAULT (datetime('now') ),
    VinhVien   BOOLEAN DEFAULT (0))''';

const String T01_Giai = '''CREATE TABLE T01_Giai (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    MaGiai   CHAR (3) NOT NULL,
    MoTaGiai VARCHAR,
    SoGiai   INT (1),
    SoCon    INT (1))''';

const String T01_KieuChoi = '''CREATE TABLE T01_KieuChoi (
    ID       INTEGER  PRIMARY KEY AUTOINCREMENT,
    Kieu     CHAR (3) UNIQUE NOT NULL,
    MoTaKieu VARCHAR,
    Nhom     INT,
    TyLe     DOUBLE
)''';


const String  T01_MaDai= '''CREATE TABLE T01_MaDai (
    ID       INTEGER  PRIMARY KEY AUTOINCREMENT
                      NOT NULL,
    MaDai    CHAR (3) UNIQUE
                      NOT NULL,
    MoTa     VARCHAR,
    Mien     CHAR (1),
    Thu      VARCHAR,
    TT       CHAR,
    NghiXoSo BOOLEAN
)''';


const String T01_MaKieu= '''CREATE TABLE T01_MaKieu (
    ID   INTEGER  PRIMARY KEY AUTOINCREMENT,
    Ma   CHAR (2) NOT NULL
                  UNIQUE,
    MoTa VARCHAR
)''';


const String T01_TuKhoa= '''CREATE TABLE T01_TuKhoa (
    ID         INTEGER PRIMARY KEY AUTOINCREMENT,
    CumTu      VARCHAR,
    ThayThe    VARCHAR,
    SoDanhHang BOOLEAN
)''';



const String TDM_GiaKhach = '''CREATE TABLE TDM_GiaKhach (
    ID      INTEGER PRIMARY KEY AUTOINCREMENT,
    KhachID INT,
    MaKieu  CHAR,
    CoMN    DOUBLE,
    ChiaMN  DOUBLE,
    TyLeMN  DOUBLE,
    TrungMN DOUBLE,
    CoMB    DOUBLE,
    ChiaMB  DOUBLE,
    TyLeMB  DOUBLE,
    TrungMB DOUBLE,
    CoMT    DOUBLE,
    ChiaMT  DOUBLE,
    TyLeMT  DOUBLE,
    TrungMT DOUBLE
)''';

const String TDM_Khach= '''CREATE TABLE TDM_Khach (
    ID        INTEGER      PRIMARY KEY AUTOINCREMENT
                           NOT NULL
                           UNIQUE,
    MaKhach   VARCHAR      UNIQUE
                           NOT NULL,
    SDT       VARCHAR (15),
    TenKhach  VARCHAR,
    GhiChu    VARCHAR,
    KDauTren  BOOLEAN,
    TheoDoi   BOOLEAN      DEFAULT (1),
    HoiTong   DOUBLE,
    Hoi2s     DOUBLE,
    Hoi3s     DOUBLE,
    ThuongMN  BOOLEAN,
    ThemChiMN BOOLEAN,
    ThuongMT  BOOLEAN,
    ThemChiMT BOOLEAN,
    ThuongMB  BOOLEAN,
    ThemChiMB BOOLEAN,
    KieuTyLe  INT          DEFAULT (1),
    tkDa      INT,
    tkAB      INT
)''';


const String TXL_KQXS= '''CREATE TABLE TXL_KQXS (
    ID     INTEGER     PRIMARY KEY AUTOINCREMENT
                       UNIQUE
                       NOT NULL,
    Ngay   DATE        NOT NULL,
    Mien   CHAR (1)    NOT NULL,
    MaDai  CHAR (3)    NOT NULL,
    MaGiai CHAR (2)    NOT NULL,
    TT     INT (2)     NOT NULL,
    KQso   VARCHAR (6) 
)''';


const String TXL_TinNhan= '''CREATE TABLE TXL_TinNhan (
    ID       INTEGER   PRIMARY KEY AUTOINCREMENT,
    Ngay     DATE,
    Phieu    CHAR (10),
    KhachID  INTEGER   NOT NULL,
    Mien     CHAR (1),
    NguonTin VARCHAR,
    DaTinh   BOOLEAN,
    GhiChu   VARCHAR,
    TongTien DOUBLE,
    DauTren  BOOLEAN
)''';


const String TXL_TinNhanCT= '''CREATE TABLE TXL_TinNhanCT (
    ID        INTEGER  PRIMARY KEY AUTOINCREMENT,
    TinNhanID BIGINT,
    DauSoDT   VARCHAR,
    GioGui    VARCHAR,
    Mien      CHAR (1),
    TinGoc    TEXT,
    TinXL     TEXT,
    CauTruc   INT
)''';



const String TXL_TinPhanTichCT= '''CREATE TABLE TXL_TinPhanTichCT (
    ID          INTEGER  PRIMARY KEY AUTOINCREMENT,
    TinNhanCTID BIGINT,
    MaTin       INT,
    MaKieu      CHAR (3),
    MaDai       VARCHAR,
    SoDanh      VARCHAR,
    SoTien      DOUBLE,
    SoLanTrung  DOUBLE,
    TienXac     DOUBLE,
    TienVon     DOUBLE,
    TienTrung   DOUBLE,
    SoDai       INT (1) 
)''';