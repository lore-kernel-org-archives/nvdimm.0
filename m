Received: from a48-181.smtp-out.amazonses.com (a48-181.smtp-out.amazonses.com [54.240.48.181])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8957416875;
	Sat, 29 Aug 2026 17:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023419; cv=none; b=MvwmrxgN7KxCCoxozu3aNVgAKFARlmSqWhuO4tXvZhjHeoYtcm8Q4Gk/CoHaVQTJue9v/ajnZWyPT8X/+GZJSjN/cMIi3/3LpdYzpVtd1CDdI6nXic6dTnwL6hIUyDkOuvXChrX9YbbwR4B9Hunk6rA3HX4noj3/0lQd7bfcCPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023419; c=relaxed/simple;
	bh=r+kKJW69qahJa08hdkRWeNNyZP+g5cFaTLPFN+XPiMM=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=iFe38V/eHg1Ph0WI8VV6tnCnx34hhJasXCgxAblhqYlXCJl1OsVTM7x4lDsfrHyl1Z5lbnD5HCmVSLEXk8gM0PXpAIbCkNIWSaHyAodNvuP2vmxnqxRxK5FEgJ/tHRkNKxxJ7tns6NXDdT1uZzc/Jm+713NQ0mLSiBNqXNl/41M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=YdmoCMd+; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=q7egb1mF; arc=none smtp.client-ip=54.240.48.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="YdmoCMd+";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="q7egb1mF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023413;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=r+kKJW69qahJa08hdkRWeNNyZP+g5cFaTLPFN+XPiMM=;
	b=YdmoCMd+j1MaS8d+qu0RLNTj/AFxv0tibwHzvSBEdsaN3Neh7Q07F7N+txQvgd2u
	U4EMesHk4/FuouEKUcjT7gRf3LaVPteVf15jZb5ZrPNoRfSw1/PNzPAJE6mQLYDdYha
	LUtBTLY8c6ebM6eWivC6nLpp8Z92GgTCpr0wO9u8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023413;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=r+kKJW69qahJa08hdkRWeNNyZP+g5cFaTLPFN+XPiMM=;
	b=q7egb1mFDPxY7+y7uuQiS+fk6PWIZW9BC6+pqUdglpS7yBO47XtxdrMZLPyR/iqW
	rbl7YYYZ3wMLq78Rbh8mPgjb+X4SpYNJR/mEHh4kwL8rkuCcoJ8M5zS8TgcFD5NyImQ
	mcPwa8sGoXIiiHD79pjC7Kbx81DZsSpJ98cZE4CA=
Subject: [PATCH V14 00/12] Subject: [PATCH v14 00/12] famfs: the
 Fabric-Attached Memory File System (standalone)
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
	=?UTF-8?Q?Jake_Edge?= <jake@lwn.net>, 
	=?UTF-8?Q?Shuah_Khan?= <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?David_Hildenbrand?= <david@kernel.org>, 
	=?UTF-8?Q?Christian_Bra?= =?UTF-8?Q?uner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Darrick_J_=2E_Wong?= <djwong@kernel.org>, 
	=?UTF-8?Q?Randy_Dunlap?= <rdunlap@infradead.org>, 
	=?UTF-8?Q?Jeff_Layton?= <jlayton@kernel.org>, 
	=?UTF-8?Q?Amir_Goldstein?= <amir73il@gmail.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?Stefan_Hajnoczi?= <shajnocz@redhat.com>, 
	=?UTF-8?Q?Joanne_Koong?= <joannelkoong@gmail.com>, 
	=?UTF-8?Q?Josef_Bacik?= <josef@toxicpanda.com>, 
	=?UTF-8?Q?Bagas_Sanjaya?= <bagasdotme@gmail.com>, 
	=?UTF-8?Q?Chen_Linxuan?= <chenlinxuan@uniontech.com>, 
	=?UTF-8?Q?James_Morse?= <james.morse@arm.com>, 
	=?UTF-8?Q?Fuad_Tabba?= <tabba@google.com>, 
	=?UTF-8?Q?Sean_Christopherson?= <seanjc@google.com>, 
	=?UTF-8?Q?Shivank_Garg?= <shivankg@amd.com>, 
	=?UTF-8?Q?Ackerley_Tng?= <ackerleytng@google.com>, 
	=?UTF-8?Q?Gregory_Pric?= =?UTF-8?Q?e?= <gourry@gourry.net>, 
	=?UTF-8?Q?Andrew_Morton?= <akpm@linux-foundation.org>, 
	=?UTF-8?Q?Namjae_Jeon?= <linkinjeon@kernel.org>, 
	=?UTF-8?Q?Lorenzo_Stoakes?= <ljs@kernel.org>, 
	=?UTF-8?Q?Greg_Kroah-Hartman?= <gregkh@linuxfoundation.org>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Pasha_Tatashin?= <pasha.tatashin@soleen.com>, 
	=?UTF-8?Q?Haren_Myneni?= <haren@linux.ibm.com>, 
	=?UTF-8?Q?Pratyush_Yadav?= <pratyush@kernel.org>, 
	=?UTF-8?Q?Giovanni_Cabiddu?= <giovanni.cabiddu@intel.com>, 
	=?UTF-8?Q?Jiri_Slaby?= <jirislaby@kernel.org>, 
	=?UTF-8?Q?Ethan_Nelson-Moo?= =?UTF-8?Q?re?= <enelsonmoore@gmail.com>, 
	=?UTF-8?Q?Gabriel_Whigham?= <gabewhigham@gmail.com>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40m?= =?UTF-8?Q?icron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40?= =?UTF-8?Q?vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?fuse-devel=40lists=2Elinux=2E?= =?UTF-8?Q?dev?= <fuse-devel@lists.linux.dev>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Sat, 29 Aug 2026 17:10:13 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260829171004.7336-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHA==
Thread-Topic: [PATCH V14 00/12] Subject: [PATCH v14 00/12] famfs: the
 Fabric-Attached Memory File System (standalone)
X-Wm-Sent-Timestamp: 1788023412
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.48.181

From: John Groves <john@groves.net>=0D=0A=0D=0AThis is v14 of famfs, as a=
 standalone file system. v13 is at [7]; v12 is=0D=0Aat [9].=0D=0A=0D=0ATh=
e intent is that v15 will be fuse again; Miklos and I have come to=0D=0Aa=
greement on a a path forward with fuse that I think is likely to work.=0D=
=0ABut this branch has r-b tags, and has some important fixes (which I've=
=0D=0Aalready cross-ported to fuse).=0D=0A=0D=0A- This series can be had =
via git as tag famfs-v15 at [10]=0D=0A- The current draft v15 (fuse) seri=
es can be had at tag famfs-v15-rc1 at [11]=0D=0A- A merge of both can be =
had as tag famfs-v14-v15-rc1 at [12]=0D=0A=0D=0A###=0D=0A=0D=0AMost of th=
is cover letter repeats v12/v13. If you have read it, skip to=0D=0A"Chang=
es since v13" below and to the per-patch changelogs under the "---"=0D=0A=
line of each patch (which carry the v14 notes). The history goes back to=20=
=0D=0A2023, and is briefly covered in the v12 cover.=0D=0A=0D=0AThe most =
important thing to know about famfs is that it CANNOT be used as a=0D=0Ag=
eneral purpose file system. It is for enabling file-based byte-level acce=
ss=0D=0A(including direct mmap) to very large (e.g. 100TB) shared/disaggr=
egated=0D=0Amemory appliances - which have become available during this l=
ong process,=0D=0Aand which are in need of Linux support.=0D=0A=0D=0ASo f=
amfs cannot be used by anybody who doesn't know why they need it. Making=0D=
=0Afamfs standalone means it can't affect users who don't use it. Micron,=
 as=0D=0Awell as other memory companies, need it, and do not intend to ab=
andon it -=0D=0Abut imagine if we did: fs/famfs/ should be removed if the=
 memory companies=0D=0Acan't be bothered to maintain it.=0D=0A=0D=0AThis =
code base has been in active CI and used globally by early adopters and=0D=
=0Atesters of disaggregated memory since 2024. I believe it is solid.=0D=0A=
=0D=0AWhy standalone (short version)=0D=0A=0D=0Afamfs was introduced at L=
PC 2023 and LSFMM 2024 [1] as a standalone file=0D=0Asystem, then spent c=
lose to a year being ported to fuse/libfuse. After=0D=0Amaintaining famfs=
 in both forms, I have concluded it makes more sense as a=0D=0Astandalone=
 file system: fuse adds complexity to famfs (more complex, less=0D=0Aadap=
table, less performant - and famfs files are memory, so access must run=0D=
=0Aat memory speed), while famfs adds complexity to fuse that is unlikely=
 to see=0D=0Aconstructive re-use. The full history and argument are in th=
e v12 cover=0D=0Aletter [9].=0D=0A=0D=0AChanges since v13=0D=0A----------=
-------=0D=0A=0D=0A- Reviewed-by tags from Darrick J. Wong and Jeff Layto=
n have been added to=0D=0A  the patches they reviewed.=0D=0A=0D=0A- The M=
AP_CREATE ioctl (patch 07) is hardened, addressing Richard Cheng's=0D=0A =
 review of v13:=0D=0A    * it now requires CAP_SYS_RAWIO, since MAP_CREAT=
E installs caller-supplied=0D=0A      device-memory mappings into a file;=
=0D=0A    * fmap validation rejects integer overflow (check_add_overflow(=
) on the=0D=0A      extent arithmetic; file_size and each interleaved ext=
ent's ie_nbytes are=0D=0A      bounded by MAX_LFS_FILESIZE);=0D=0A    * i=
nterleaved (striped) fmap coverage is validated at ingest -- the sum of=0D=
=0A      the interleaved extents' ie_nbytes must reach file_size, and eac=
h strip=0D=0A      must physically hold the chunks striped onto it -- so =
a malformed striped=0D=0A      file is rejected with -EINVAL rather than =
faulting (SIGBUS) on access.=0D=0A=0D=0A- Rebased onto v7.2.=0D=0A=0D=0AT=
he full v12 -> v13 change list is in the v13 cover [7] and in the per-pat=
ch=0D=0A"---" changelogs.=0D=0A=0D=0AFamfs Overview=0D=0A=0D=0AFamfs expo=
ses sharable disaggregated memory as a file system. Famfs consumes=0D=0As=
hared memory from [usually shared memory] dax devices, and provides=0D=0A=
memory-mappable files that map directly to the memory - no page cache=0D=0A=
involvement. Famfs differs from conventional file systems in fs-dax mode,=
=0D=0Ain that it handles in-memory metadata in a sharable way (which begi=
ns with=0D=0Anever caching dirty shared metadata). So a famfs file system=
 can be mounted=0D=0Afrom multiple nodes, provided they have access to th=
e memory.=0D=0A=0D=0AThe key performance requirement is that famfs must r=
esolve mapping faults=0D=0Awith minimal overhead. This is achieved by ful=
ly caching the file-to-devdax=0D=0Ametadata for all active files.=0D=0A=0D=
=0AFamfs remains the first fs-dax file system that is backed by devdax ra=
ther=0D=0Athan pmem in fs-dax mode (hence the need for the new dax mode).=
=0D=0A=0D=0AFamfs depends on the 'fsdev' dax mode which landed in 7.1 - i=
t will only run=0D=0Awith an fsdev-mode (aka famfs-mode) daxdev as its ba=
cking device(s).=0D=0A=0D=0AThe famfs user space can be found at [6].=0D=0A=
=0D=0A[1] https://lwn.net/Articles/983105/ (Famfs at LSFMM 2024)=0D=0A[2]=
 https://lwn.net/Articles/1020170/ (Famfs at LSFMM 2025, with patch link)=
=0D=0A[3] https://lwn.net/Articles/1068686/ (LWN coverage of the patch th=
read)=0D=0A[4] https://lwn.net/Articles/1082687/ (Famfs at LSFMM 2026)=0D=
=0A[5] https://lore.kernel.org/linux-fsdevel/0100019f7d9fbe81-6cb16662-25=
22-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com/#b=0D=0A[6] https://=
famfs.org=0D=0A[7] FIXME: v13 lore link=0D=0A[8] https://lore.kernel.org/=
linux-cxl/0100019fd478eb93-a6bd48e4-b5f1-4871-93d4-582802956e6c-000000@em=
ail.amazonses.com/T/#u (Partial dax patch)=0D=0A[9] https://lore.kernel.o=
rg/linux-fsdevel/20260806053409.GL3560084@frogsfrogsfrogs/T/#t (v12)=0D=0A=
[10] https://github.com/jagalactic/linux/tree/famfs-v14=0D=0A[11] https:/=
/github.com/jagalactic/linux/tree/famfs-v15-rc1=0D=0A[12] https://github.=
com/jagalactic/linux/tree/famfs-v14-v15-rc1=0D=0A=0D=0A=0D=0AJohn Groves =
(12):=0D=0A  dax: replace exported dax_dev_get() with non-allocating dax_=
dev_find()=0D=0A  famfs: Module operations, fs_context, and mount=0D=0A  =
famfs: Add daxdev table and dax notify_failure support=0D=0A  famfs: Intr=
oduce inode_operations and super_operations=0D=0A  famfs: Introduce file_=
operations read/write=0D=0A  famfs: Introduce mmap and VM fault handling=0D=
=0A  famfs: MAP_CREATE ioctl and fmap ingest (ABI 44)=0D=0A  famfs: iomap=
_begin and file-to-dax offset resolution=0D=0A  famfs: Register secondary=
 daxdevs by path (FAMFSIOC_DAXDEV_OPEN)=0D=0A  famfs: Add runtime operati=
on-permission (opts) framework=0D=0A  famfs: Report device capacity via s=
tatfs so df works=0D=0A  famfs: Add documentation=0D=0A=0D=0A Documentati=
on/filesystems/famfs.rst           |  142 +++=0D=0A Documentation/filesys=
tems/index.rst           |    1 +=0D=0A .../userspace-api/ioctl/ioctl-num=
ber.rst      |    1 +=0D=0A MAINTAINERS                                  =
 |    8 +=0D=0A drivers/dax/fsdev.c                           |   19 +=0D=
=0A drivers/dax/super.c                           |   38 +-=0D=0A fs/Kcon=
fig                                    |    2 +=0D=0A fs/Makefile        =
                           |    1 +=0D=0A fs/famfs/Kconfig               =
               |   12 +=0D=0A fs/famfs/Makefile                          =
   |    5 +=0D=0A fs/famfs/famfs_file.c                         | 1070 ++=
+++++++++++++++=0D=0A fs/famfs/famfs_inode.c                        |  86=
9 +++++++++++++=0D=0A fs/famfs/famfs_internal.h                     |  16=
2 +++=0D=0A fs/namei.c                                    |    1 +=0D=0A =
fs/super.c                                    |    7 +=0D=0A include/linu=
x/dax.h                           |    7 +-=0D=0A include/linux/fs.h     =
                       |    1 +=0D=0A include/uapi/linux/famfs_ioctl.h   =
           |  160 +++=0D=0A include/uapi/linux/magic.h                   =
 |    1 +=0D=0A 19 files changed, 2504 insertions(+), 3 deletions(-)=0D=0A=
 create mode 100644 Documentation/filesystems/famfs.rst=0D=0A create mode=
 100644 fs/famfs/Kconfig=0D=0A create mode 100644 fs/famfs/Makefile=0D=0A=
 create mode 100644 fs/famfs/famfs_file.c=0D=0A create mode 100644 fs/fam=
fs/famfs_inode.c=0D=0A create mode 100644 fs/famfs/famfs_internal.h=0D=0A=
 create mode 100644 include/uapi/linux/famfs_ioctl.h=0D=0A=0D=0A--=20=0D=0A=
2.53.0=0D=0A=0D=0A
