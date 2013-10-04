namespace Mee.IO
{
	public enum DriveType
	{
		Unknown   = 0,
		NoRootDir = 1,
		Removable = 2,
		Fixed     = 3,
		Remote    = 4,
		CDRom     = 5,
		RamDisk   = 6
	}
	
	internal enum SysV
	{
		None  = 0,
		Xenix = 1,
		SysV4 = 2,
		SysV2 = 3,
		Coh   = 4
	}
	
	internal enum MagicType
	{
		AdFSSuper   = 0xadf5,
		AfFSSuper    = 0xadff,
		AFSSuper    = 0x5346414F,
		AutoFSSbi   = 0x6d4a556d,
		AutoFSSuper = 0x0187,
		CodaSuper	= 0x73757245,
		CramFS		= 0x28cd3d45,	/* some random number */
		CramFSWend  = 0x453dcd28,	/* magic number with the wrong endianess */
		DebugFS     = 0x64626720,
		SecurityFS  = 0x73636673,
		SeLinux	    = 0xf97cff8c,
		Smack		= 0x43415d53,	/* "SMAC" */
		RamFS		= 0x858458f6,	/* some random number */
		TmpFS		= 0x01021994,
		HugetLbFS   = 0x958458f6,	/* some random number */
		SquashFS    = 0x73717368,
		EcryptFSSuper	= 0xf15f,
		EFSSuper	= 0x414A53,
		Ext2Super	= 0xEF53,
		Ext3Super   = 0xEF53,
		XenFSSuper	= 0xabba1974,
		Ext4Super	= 0xEF53,
		BtrFSSuper	= 0x9123683E,
		NilFSSuper	= 0x3434,
		F2FSSuper	= 0xF2F52010,
		HPFSSuper	= 0xf995e849,
		IsoFSSuper	= 0x9660,
		JFSSuper    = 0x3153464a,
		JFFS2Super	= 0x72b6,
		PStoreFS    = 0x6165676C,
		EFIVarFS    = 0xde5e81e4,
		HostFSSuper	= 0x00c0ffee,
		MinixSuper	= 0x137F,		/* minix v1 fs, 14 char names */
		MinixSuper2	= 0x138F,		/* minix v1 fs, 30 char names */
		Minix2Super	= 0x2468,		/* minix v2 fs, 14 char names */
		Minix2Super2	= 0x2478,		/* minix v2 fs, 30 char names */
		Minix3Super	= 0x4d5a,		/* minix v3 fs, 60 char names */
		MsDosSuper  = 0x4d44,		/* MD */
		NCPSuper	= 0x564c,		/* Guess, what = 0x564c is :-) */
		NFSSuper	= 0x6969,
		OpenPROMSuper = 0x9fa1,
		QNX4Super	= 0x002f,		/* qnx4 fs detection */
		QNX6Super	= 0x68191122,	/* qnx6 fs detection */
		ReiserFSSuper = 0x52654973,	/* used by gcc */
		SMBSuper	= 0x517B,
		CGroupSuper	= 0x27e0eb,
		StackEnd	= 0x57AC6E9D,
		V9FS		= 0x01021997,
		BDevFS      = 0x62646576,
		BinFmtFS    = 0x42494e4d,
		DEVPTSSuper	= 0x1cd1,
		CiFSNumber  = 0xFF534D42,
		FutexFSSuper = 0xBAD1DEA,
		PipeFS      = 0x50495045,
		ProcSuper	= 0x9fa0,
		SockFS		= 0x534F434B,
		SysFS		= 0x62656572,
		USBDeviceSuper	= 0x9fa2,
		MTDInodeFS  = 0x11307854,
		AnonInodeFS	= 0x09041934,
		HFSSuper    = 0x4244,
		HFSPlusSuper = 0x482b,
		NtFSSB      = 0x5346544e,
		RomFS       = 0x7275,
		SysVBase    = 0x012FF7B3,
		XenixSuper  = MagicType.SysVBase + SysV.Xenix,
		SysV4Super  = MagicType.SysVBase + SysV.SysV4,
		SysV2Super  = MagicType.SysVBase + SysV.SysV2,
		CohSuper    = MagicType.SysVBase + SysV.Coh,
		UdfSuper    = 0x15013346,
		UFS         = 0x00011954,
		UFSBW       = 0x0f242697,
		UFS2        = 0x19540119,
		UFSCigam    = 0x54190100,
		XFSSB       = 0x58465342,
		FuseSuper   = 0x65735546,
		CephSuper   = 0x00c36400,
		ConfigFS    = 0x62656570,
		ExoFSSuper  = 0x5df5,
		VxFSSuper   = 0xa501fcf5,
		VxFSOlt     = 0xa504fcf5,
		GFS2        = 0x01161970,
		LogFSu32    = 0xc97e8168,
		OcFS2Super  = 0x7461636f,
		OMFS        = 0xc2993d87,
		UbiFSSuper  = 0x24051905
	}
	
	internal struct ApiDriveType
	{
		public DriveType type;
		public MagicType typeid;
		public string fstype;
		
		public ApiDriveType (DriveType dt, MagicType mt, string t){
			type = dt;
			typeid = mt;
			fstype = t;
		}
	}
	
	internal ApiDriveType[] get_drive_types(){
		ApiDriveType[] adt = new ApiDriveType[]{
			ApiDriveType( DriveType.Fixed, MagicType.AdFSSuper, "adfs"),
	ApiDriveType( DriveType.Fixed, MagicType.AfFSSuper, "affs"),
	ApiDriveType( DriveType.Remote, MagicType.AFSSuper, "afs"),
	ApiDriveType( DriveType.RamDisk, MagicType.AutoFSSuper, "autofs"),
	ApiDriveType( DriveType.RamDisk, MagicType.AutoFSSbi, "autofs4"),
	ApiDriveType( DriveType.Remote, MagicType.CodaSuper, "coda" ),
	ApiDriveType( DriveType.RamDisk, MagicType.CramFS, "cramfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.CramFSWend, "cramfs"),
	ApiDriveType( DriveType.Remote, MagicType.CiFSNumber, "cifs"),
	ApiDriveType( DriveType.RamDisk, MagicType.DebugFS, "debugfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.SysFS, "sysfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.SecurityFS, "securityfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.SeLinux, "selinuxfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.RamFS, "ramfs"),
	ApiDriveType( DriveType.Fixed, MagicType.SquashFS, "squashfs"),
	ApiDriveType( DriveType.Fixed, MagicType.EFSSuper, "efs"),
	ApiDriveType( DriveType.Fixed, MagicType.Ext2Super, "ext2"),
	ApiDriveType( DriveType.Fixed, MagicType.Ext3Super, "ext3"),
	ApiDriveType( DriveType.Fixed, MagicType.Ext4Super, "ext4"),
	ApiDriveType( DriveType.Remote, MagicType.XenFSSuper, "xenfs"),
	ApiDriveType( DriveType.Fixed, MagicType.BtrFSSuper, "btrfs"),
	ApiDriveType( DriveType.Fixed, MagicType.HFSSuper, "hfs"),
	ApiDriveType( DriveType.Fixed, MagicType.HFSPlusSuper, "hfsplus"),
	ApiDriveType( DriveType.Fixed, MagicType.HPFSSuper, "hpfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.HugetLbFS, "hugetlbfs"),
	ApiDriveType( DriveType.CDRom, MagicType.IsoFSSuper, "iso"),
	ApiDriveType( DriveType.Fixed, MagicType.JFFS2Super, "jffs2"),
	ApiDriveType( DriveType.RamDisk, MagicType.AnonInodeFS, "anon_inode"),
	ApiDriveType( DriveType.Fixed, MagicType.JFSSuper, "jfs"),
	ApiDriveType( DriveType.Fixed, MagicType.MinixSuper, "minix"),
	ApiDriveType( DriveType.Fixed, MagicType.MinixSuper2, "minix v2"),
	ApiDriveType( DriveType.Fixed, MagicType.Minix2Super, "minix2"),
	ApiDriveType( DriveType.Fixed, MagicType.Minix2Super2, "minix2 v2"),
	ApiDriveType( DriveType.Fixed, MagicType.Minix3Super, "minix3"),
	ApiDriveType( DriveType.Fixed, MagicType.MsDosSuper, "msdos"),
	ApiDriveType( DriveType.Remote, MagicType.NCPSuper, "ncp"),
	ApiDriveType( DriveType.Remote, MagicType.NFSSuper, "nfs"),
	ApiDriveType( DriveType.Fixed, MagicType.NtFSSB, "ntfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.OpenPROMSuper, "openpromfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.ProcSuper, "proc"),
	ApiDriveType( DriveType.Fixed, MagicType.QNX4Super, "qnx4"),
	ApiDriveType( DriveType.Fixed, MagicType.ReiserFSSuper, "reiserfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.RomFS, "romfs"),
	ApiDriveType( DriveType.Remote, MagicType.SMBSuper, "samba"),
	ApiDriveType( DriveType.RamDisk, MagicType.CGroupSuper, "cgroupfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.FutexFSSuper, "futexfs"),
	ApiDriveType( DriveType.Fixed, MagicType.SysV2Super, "sysv2"),
	ApiDriveType( DriveType.Fixed, MagicType.SysV4Super, "sysv4"),
	ApiDriveType( DriveType.RamDisk, MagicType.TmpFS, "tmpfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.DEVPTSSuper, "devpts"),
	ApiDriveType( DriveType.CDRom, MagicType.UdfSuper, "udf"),
	ApiDriveType( DriveType.Fixed, MagicType.UFS, "ufs"),
	ApiDriveType( DriveType.Fixed, MagicType.UFSBW, "ufs"),
	ApiDriveType( DriveType.Fixed, MagicType.UFS2, "ufs2"),
	ApiDriveType( DriveType.Fixed, MagicType.UFSCigam, "ufs_cigam"),
	ApiDriveType( DriveType.RamDisk, MagicType.USBDeviceSuper, "usbdev"),
	ApiDriveType( DriveType.Fixed, MagicType.XenixSuper, "xenix"),
	ApiDriveType( DriveType.Fixed, MagicType.XFSSB, "xfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.FuseSuper, "fuse"),
	ApiDriveType( DriveType.Fixed, MagicType.V9FS, "9p"),
	ApiDriveType( DriveType.Remote, MagicType.CephSuper, "ceph"),
	ApiDriveType( DriveType.RamDisk, MagicType.ConfigFS, "configfs"),
	ApiDriveType( DriveType.RamDisk, MagicType.EcryptFSSuper, "eCryptfs"),
	ApiDriveType( DriveType.Fixed, MagicType.ExoFSSuper, "exofs"),
	ApiDriveType( DriveType.Fixed, MagicType.VxFSSuper, "vxfs"),
	ApiDriveType( DriveType.Fixed, MagicType.VxFSOlt, "vxfs_olt"),
	ApiDriveType( DriveType.Remote, MagicType.GFS2, "gfs2"),
	ApiDriveType( DriveType.Fixed, MagicType.LogFSu32, "logfs"),
	ApiDriveType( DriveType.Fixed, MagicType.OcFS2Super, "ocfs2"),
	ApiDriveType( DriveType.Fixed, MagicType.OMFS, "omfs"),
	ApiDriveType( DriveType.Fixed, MagicType.UbiFSSuper, "ubifs"),
	ApiDriveType( DriveType.Unknown, 0, "***")
		};
		return adt;
	}
	
	internal static string get_drive_type_name (string path, out DriveType type){
		ApiDriveType[] adt = get_drive_types ();
		int i = 0;
		fsstat stat;
		statfs (path, out stat);
		while(adt[i].type != DriveType.Unknown){
			if((uint)adt[i].typeid == stat.f_type){
				type = adt[i].type;
				return adt[i].fstype;
			}
			i++;
		}
		return null;
	}
	

}
