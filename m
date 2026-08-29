Received: from a11-71.smtp-out.amazonses.com (a11-71.smtp-out.amazonses.com [54.240.11.71])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785CE41A4FF;
	Sat, 29 Aug 2026 17:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023527; cv=none; b=tFJgzebkqsioCO9zwuiwjaUKfVgHMvy4HXJV9zLGCenS+aZ9L/PkZ6DpnYiGg7bo27hRXbEk9kXISOdQSdAOeWhHFeMvXGV2VAu67OwHzP9n4Z7ccIMx5uED0+hpVTX7LL7kAVDyQ0fsc36qcYmcFlxinG0wOXKxTlUxV2x3V0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023527; c=relaxed/simple;
	bh=T+wyU1NPnx7Wc890JDi5qXavjMR+IEVK+7wPD5HBwxs=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=kJYNs8Prl55i3kMjAmpqHBp+11e0nwzKoc0osFbavWvLYYxynk0WyW1cJYIz7I7eg2qtkw+Vpy1buwNSzDLRfbFxcAq8Kyo1rnGPGQRHdyyfY0e/t5/b3aeOK2VWmu5uIUBv3w+CdKMotMWaVCLd5pXSyJpOk6+8BDgquaG2eN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=N4Dh8NMm; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=a4kfjzpv; arc=none smtp.client-ip=54.240.11.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="N4Dh8NMm";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="a4kfjzpv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023519;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=T+wyU1NPnx7Wc890JDi5qXavjMR+IEVK+7wPD5HBwxs=;
	b=N4Dh8NMmw36uaQGYueHHbyDehckX4EWtx7v5RJjWgcPvxlPCXra84VIhZdpglHiU
	/M0pQMReLI0oHf0EgFL/MuKuKZSxldQS4PZ9OtqcrqWi4bI20Bh6OeAcvWpB/4r8PW3
	4EcMWpuUU+0bys2MQnKWMtE9HFlUWoRoF+x+0muk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023519;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=T+wyU1NPnx7Wc890JDi5qXavjMR+IEVK+7wPD5HBwxs=;
	b=a4kfjzpvvqEe55lWw7yvPh9H3iouJTP+n+NnVzRVMPuBsrgg8GpOVnewj22B0O7o
	hFrTGSJLfIYubSObtZ/dbA2gXl+MbKUBlm/Kr0eVUR71MvCSf3GvNB4jBLa2EHmJ6Vg
	0jMdXFN1trimjienA/co/LagVmRj7VzAIhFWQRd0=
Subject: [PATCH V14 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI 44)
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
Date: Sat, 29 Aug 2026 17:11:58 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
References: 
 <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com> 
 <20260829171148.7467-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHAAAD6od
Thread-Topic: [PATCH V14 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
X-Wm-Sent-Timestamp: 1788023517
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e81b68e-8f5128b9-249f-49af-be87-024b15eb0bd9-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.11.71

From: John Groves <John@Groves.net>=0D=0A=0D=0AAdd the famfs file ioctl h=
andler (FAMFSIOC_NOP, FAMFSIOC_MAP_CREATE) and=0D=0Athe KABI-44 self-desc=
ribing fmap message: the wire ABI in famfs_ioctl.h=0D=0A(famfs_ioc_fmap_h=
eader plus the simple and interleaved extent structs), the=0D=0Ain-core f=
amfs_file_meta, and famfs_file_init_dax(), which copies the=0D=0Amessage =
in, parses both the simple-extent and interleaved (striped) wire=0D=0Afor=
ms into inode->i_private, and sets S_DAX.=0D=0A=0D=0AResolving those mapp=
ings to dax-device offsets (iomap_begin) is added in=0D=0Athe following c=
ommit; the read/write/fault paths keep their NULL iomap_ops=0D=0Astub unt=
il then.=0D=0A=0D=0AFamfs now accepts extent and chunk alignment at eithe=
r PMD or PTE. PMD=0D=0Ais the normal case, and it guarantees PMD faults -=
 which is right for=0D=0Alarge files, which are the original use case. Bu=
t there are also active=0D=0Ause cases that use zillions of small files, =
and those need PTE support=0D=0Ato avoid big space amplification.=0D=0A=0D=
=0AAlso add famfs ioctls to ioctl-number.rst=0D=0A=0D=0AReviewed-by: Jeff=
 Layton <jlayton@kernel.org>=0D=0ASigned-off-by: John Groves <john@groves=
=2Enet>=0D=0A---=0D=0Av14:=0D=0A - Require CAP_SYS_RAWIO in the MAP_CREAT=
E handler (famfs_file_init_dax()).=0D=0A   MAP_CREATE installs caller-sup=
plied device-memory mappings into a file,=0D=0A   so it now demands CAP_S=
YS_RAWIO in addition to the mount-wide=0D=0A   FAMFS_OPT_MAP_CREATE polic=
y gate (Richard Cheng).=0D=0A - Reject integer overflow while validating =
a caller-supplied fmap. Each=0D=0A   extent's ext_offset + ext_len and th=
e running extent_total are now=0D=0A   accumulated with check_add_overflo=
w(), and file_size (and each=0D=0A   interleaved extent's ie_nbytes) is b=
ounded by MAX_LFS_FILESIZE. Without=0D=0A   this an overflowing extent co=
uld wrap a dax offset back toward 0 and=0D=0A   resolve to the wrong memo=
ry (Richard Cheng; Darrick Wong).=0D=0A - Validate interleaved (striped) =
fmap coverage at ingest, so a malformed=0D=0A   striped file is rejected =
with -EINVAL at MAP_CREATE rather than faulting=0D=0A   (SIGBUS) on acces=
s. Two checks: (a) the sum of the interleaved extents'=0D=0A   ie_nbytes =
must reach file_size (logical coverage); and (b) each strip=0D=0A   must =
physically hold the chunks striped onto it -- checked by probing=0D=0A   =
the highest file offset that lands on each strip (the last byte of each=0D=
=0A   top-row chunk) and resolving it with the same arithmetic the fault =
path=0D=0A   uses, which is partial-final-chunk aware and assumes nothing=
 about=0D=0A   relative strip sizes. Previously the check subtracted phys=
ical strip=0D=0A   ext_len from file_size, conflating physical allocation=
 with logical=0D=0A   coverage (Richard Cheng). This is also the MAP_CREA=
TE-time interleaved=0D=0A   validation discussed with Darrick Wong on the=
 opts patch.=0D=0A=0D=0A .../userspace-api/ioctl/ioctl-number.rst      | =
  1 +=0D=0A fs/famfs/famfs_file.c                         | 387 +++++++++=
++++++++-=0D=0A fs/famfs/famfs_inode.c                        |   1 +=0D=0A=
 fs/famfs/famfs_internal.h                     |  46 +++=0D=0A include/ua=
pi/linux/famfs_ioctl.h              |  91 ++++=0D=0A 5 files changed, 525=
 insertions(+), 1 deletion(-)=0D=0A create mode 100644 include/uapi/linux=
/famfs_ioctl.h=0D=0A=0D=0Adiff --git a/Documentation/userspace-api/ioctl/=
ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst=0D=0A=
index 3f0ef1e27eb0..5e244dec1b98 100644=0D=0A--- a/Documentation/userspac=
e-api/ioctl/ioctl-number.rst=0D=0A+++ b/Documentation/userspace-api/ioctl=
/ioctl-number.rst=0D=0A@@ -299,6 +299,7 @@ Code  Seq#    Include File    =
                                         Comments=0D=0A 'u'   00-2F  linu=
x/ublk_cmd.h                                          conflict!=0D=0A 'u'=
   20-3F  linux/uvcvideo.h                                          USB v=
ideo class host driver=0D=0A 'u'   40-4f  linux/udmabuf.h                =
                           userspace dma-buf misc device=0D=0A+'u'   50-5=
F  linux/famfs_ioctl.h                                       famfs shared=
 memory file system=0D=0A 'v'   00-1F  linux/ext2_fs.h                   =
                        conflict!=0D=0A 'v'   00-1F  linux/fs.h          =
                                      conflict!=0D=0A 'v'   00-0F  linux/=
sonypi.h                                            conflict!=0D=0Adiff -=
-git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c=0D=0Aindex 9c1cd2f67=
489..f099e0d08673 100644=0D=0A--- a/fs/famfs/famfs_file.c=0D=0A+++ b/fs/f=
amfs/famfs_file.c=0D=0A@@ -13,9 +13,377 @@=0D=0A #include <linux/mm.h>=0D=
=0A #include <linux/dax.h>=0D=0A #include <linux/iomap.h>=0D=0A+#include =
<linux/capability.h>=0D=0A+#include <linux/overflow.h>=0D=0A=20=0D=0A+#in=
clude <linux/famfs_ioctl.h>=0D=0A #include "famfs_internal.h"=0D=0A=20=0D=
=0A+/* Expose famfs kernel abi version as a read-only module parameter */=
=0D=0A+static int kabi_version =3D FAMFS_KABI_VERSION;=0D=0A+module_param=
(kabi_version, int, 0444);=0D=0A+MODULE_PARM_DESC(kabi_version, "famfs ke=
rnel abi version");=0D=0A+=0D=0A+void=0D=0A+famfs_meta_free(struct famfs_=
file_meta *map)=0D=0A+{=0D=0A+=09if (map) {=0D=0A+=09=09switch (map->fm_e=
xtent_type) {=0D=0A+=09=09case FAMFS_IOC_EXT_SIMPLE:=0D=0A+=09=09=09kfree=
(map->se);=0D=0A+=09=09=09break;=0D=0A+=09=09case FAMFS_IOC_EXT_INTERLEAV=
E:=0D=0A+=09=09=09if (map->ie) {=0D=0A+=09=09=09=09u32 i;=0D=0A+=0D=0A+=09=
=09=09=09for (i =3D 0; i < map->fm_niext; i++)=0D=0A+=09=09=09=09=09kfree=
(map->ie[i].ie_strips);=0D=0A+=09=09=09}=0D=0A+=09=09=09kfree(map->ie);=0D=
=0A+=09=09=09break;=0D=0A+=09=09default:=0D=0A+=09=09=09break;=0D=0A+=09=09=
}=0D=0A+=09}=0D=0A+=09kfree(map);=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+f=
amfs_check_ext_alignment(struct famfs_meta_simple_ext *se)=0D=0A+{=0D=0A+=
=09int errs =3D 0;=0D=0A+=0D=0A+=09if (!IS_ALIGNED(se->ext_offset, PAGE_S=
IZE))=0D=0A+=09=09errs++;=0D=0A+=09if (!IS_ALIGNED(se->ext_len, PAGE_SIZE=
))=0D=0A+=09=09errs++;=0D=0A+=0D=0A+=09return errs;=0D=0A+}=0D=0A+=0D=0A+=
/**=0D=0A+ * famfs_file_init_dax() - FAMFSIOC_MAP_CREATE ioctl handler=0D=
=0A+ * @file: the un-initialized file=0D=0A+ * @arg:  user pointer to a s=
elf-describing fmap message=0D=0A+ *=0D=0A+ * The map-create ioctl carrie=
s the fmap as a self-describing message: a=0D=0A+ * struct famfs_ioc_fmap=
_header followed by an extent list. The message is=0D=0A+ * copied in, pa=
rsed into a famfs_file_meta, and published on inode->i_private.=0D=0A+ * =
Both the simple-extent and the interleaved (striped) wire forms are handl=
ed.=0D=0A+ * The wire layout byte-matches the fmap carried in a fuse famf=
s GET_FMAP reply.=0D=0A+ */=0D=0A+static int=0D=0A+famfs_file_init_dax(st=
ruct file *file, void __user *arg)=0D=0A+{=0D=0A+=09struct famfs_ioc_fmap=
_header fmh;=0D=0A+=09struct famfs_file_meta *meta =3D NULL;=0D=0A+=09str=
uct famfs_fs_info *fsi;=0D=0A+=09struct super_block *sb;=0D=0A+=09struct =
inode *inode;=0D=0A+=09void *fmap_buf =3D NULL;=0D=0A+=09size_t extent_to=
tal =3D 0;=0D=0A+=09size_t next_offset;=0D=0A+=09int errs =3D 0;=0D=0A+=09=
int rc;=0D=0A+=09u32 i, j;=0D=0A+=09u64 ext_end;=0D=0A+=0D=0A+=09inode =3D=
 file_inode(file);=0D=0A+=09if (!inode)=0D=0A+=09=09return -EBADF;=0D=0A+=
=09if (inode->i_private)=0D=0A+=09=09return -EEXIST;=0D=0A+=0D=0A+=09sb  =
=3D inode->i_sb;=0D=0A+=09fsi =3D sb->s_fs_info;=0D=0A+=09if (fsi->deverr=
or)=0D=0A+=09=09return -ENODEV;=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMF=
S_OPT_MAP_CREATE))=0D=0A+=09=09return -EPERM;=0D=0A+=09/* MAP_CREATE maps=
 caller-supplied device memory; require CAP_SYS_RAWIO */=0D=0A+=09if (!ca=
pable(CAP_SYS_RAWIO))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09if (copy=
_from_user(&fmh, arg, sizeof(fmh)))=0D=0A+=09=09return -EFAULT;=0D=0A+=0D=
=0A+=09if (fmh.fmap_version !=3D FAMFS_FMAP_VERSION)=0D=0A+=09=09return -=
EINVAL;=0D=0A+=09if (fmh.fmap_size < sizeof(fmh))=0D=0A+=09=09return -EIN=
VAL;=0D=0A+=09if (fmh.fmap_size > FAMFS_FMAP_MSG_MAX)=0D=0A+=09=09return =
-EFBIG;=0D=0A+=09if (fmh.nextents < 1)=0D=0A+=09=09return -EINVAL;=0D=0A+=
=09if (fmh.file_size > MAX_LFS_FILESIZE)=0D=0A+=09=09return -EINVAL;=0D=0A=
+=0D=0A+=09fmap_buf =3D kvmalloc(fmh.fmap_size, GFP_KERNEL);=0D=0A+=09if =
(!fmap_buf)=0D=0A+=09=09return -ENOMEM;=0D=0A+=0D=0A+=09if (copy_from_use=
r(fmap_buf, arg, fmh.fmap_size)) {=0D=0A+=09=09rc =3D -EFAULT;=0D=0A+=09=09=
goto out;=0D=0A+=09}=0D=0A+=09next_offset =3D sizeof(fmh);=09/* start of =
the extent list */=0D=0A+=0D=0A+=09meta =3D kzalloc_obj(*meta, GFP_KERNEL=
);=0D=0A+=09if (!meta) {=0D=0A+=09=09rc =3D -ENOMEM;=0D=0A+=09=09goto out=
;=0D=0A+=09}=0D=0A+=0D=0A+=09meta->error =3D false;=0D=0A+=09meta->file_t=
ype =3D fmh.file_type;=0D=0A+=09meta->file_size =3D fmh.file_size;=0D=0A+=
=09meta->fm_extent_type =3D fmh.ext_type;=0D=0A+=0D=0A+=09switch (fmh.ext=
_type) {=0D=0A+=09case FAMFS_IOC_EXT_SIMPLE: {=0D=0A+=09=09struct famfs_i=
oc_simple_ext *se_in =3D fmap_buf + next_offset;=0D=0A+=0D=0A+=09=09next_=
offset +=3D (size_t)fmh.nextents * sizeof(*se_in);=0D=0A+=09=09if (next_o=
ffset > fmh.fmap_size) {=0D=0A+=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09go=
to out;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09meta->fm_nextents =3D fmh.nexten=
ts;=0D=0A+=09=09meta->se =3D kcalloc(meta->fm_nextents, sizeof(*meta->se)=
,=0D=0A+=09=09=09=09   GFP_KERNEL);=0D=0A+=09=09if (!meta->se) {=0D=0A+=09=
=09=09rc =3D -ENOMEM;=0D=0A+=09=09=09goto out;=0D=0A+=09=09}=0D=0A+=0D=0A=
+=09=09for (i =3D 0; i < fmh.nextents; i++) {=0D=0A+=09=09=09meta->se[i].=
dev_index  =3D se_in[i].se_devindex;=0D=0A+=09=09=09meta->se[i].ext_offse=
t =3D se_in[i].se_offset;=0D=0A+=09=09=09meta->se[i].ext_len    =3D se_in=
[i].se_len;=0D=0A+=0D=0A+=09=09=09if (meta->se[i].dev_index >=3D FAMFS_MA=
X_DAXDEVS) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out=
;=0D=0A+=09=09=09}=0D=0A+=09=09=09if (check_add_overflow(meta->se[i].ext_=
offset,=0D=0A+=09=09=09=09=09       meta->se[i].ext_len, &ext_end) ||=0D=0A=
+=09=09=09    check_add_overflow(extent_total,=0D=0A+=09=09=09=09=09     =
  meta->se[i].ext_len,=0D=0A+=09=09=09=09=09       &extent_total)) {=0D=0A=
+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=09=09}=
=0D=0A+=09=09=09meta->dev_bitmap |=3D BIT_ULL(meta->se[i].dev_index);=0D=0A=
+=09=09=09errs +=3D famfs_check_ext_alignment(&meta->se[i]);=0D=0A+=09=09=
}=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=0D=0A+=09case FAMFS_IOC_EXT_INTERL=
EAVE: {=0D=0A+=09=09u64 logical_total =3D 0;=0D=0A+=09=09u32 niext =3D fm=
h.nextents;=0D=0A+=0D=0A+=09=09meta->fm_niext =3D niext;=0D=0A+=09=09meta=
->ie =3D kcalloc(niext, sizeof(*meta->ie), GFP_KERNEL);=0D=0A+=09=09if (!=
meta->ie) {=0D=0A+=09=09=09rc =3D -ENOMEM;=0D=0A+=09=09=09goto out;=0D=0A=
+=09=09}=0D=0A+=0D=0A+=09=09/* Outer loop is over the separate interleave=
d extents */=0D=0A+=09=09for (i =3D 0; i < niext; i++) {=0D=0A+=09=09=09s=
truct famfs_ioc_iext *ie_in =3D fmap_buf + next_offset;=0D=0A+=09=09=09st=
ruct famfs_ioc_simple_ext *sie_in;=0D=0A+=09=09=09u64 nstrips;=0D=0A+=09=09=
=09u64 chunks;=0D=0A+=09=09=09u64 n, nprobe;=0D=0A+=0D=0A+=09=09=09next_o=
ffset +=3D sizeof(*ie_in);=0D=0A+=09=09=09if (next_offset > fmh.fmap_size=
) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=
=09=09}=0D=0A+=0D=0A+=09=09=09/* chunk_size must be exactly one supported=
 alloc unit */=0D=0A+=09=09=09if (ie_in->ie_chunk_size !=3D PAGE_SIZE &&=0D=
=0A+=09=09=09    ie_in->ie_chunk_size !=3D PMD_SIZE) {=0D=0A+=09=09=09=09=
rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=09=09}=0D=0A+=09=09=
=09if (ie_in->ie_nbytes =3D=3D 0 ||=0D=0A+=09=09=09    ie_in->ie_nbytes >=
 MAX_LFS_FILESIZE) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09=
goto out;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09nstrips =3D ie_in->ie_ns=
trips;=0D=0A+=09=09=09if (nstrips < 1) {=0D=0A+=09=09=09=09rc =3D -EINVAL=
;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09meta=
->ie[i].fie_chunk_size =3D ie_in->ie_chunk_size;=0D=0A+=09=09=09meta->ie[=
i].fie_nstrips    =3D ie_in->ie_nstrips;=0D=0A+=09=09=09meta->ie[i].fie_n=
bytes     =3D ie_in->ie_nbytes;=0D=0A+=0D=0A+=09=09=09chunks =3D DIV_ROUN=
D_UP(ie_in->ie_nbytes,=0D=0A+=09=09=09=09=09      ie_in->ie_chunk_size);=0D=
=0A+=0D=0A+=09=09=09/* The strip extents follow the interleaved-ext heade=
r */=0D=0A+=09=09=09sie_in =3D fmap_buf + next_offset;=0D=0A+=09=09=09nex=
t_offset +=3D nstrips * sizeof(*sie_in);=0D=0A+=09=09=09if (next_offset >=
 fmh.fmap_size) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09got=
o out;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09meta->ie[i].ie_strips =3D=0D=
=0A+=09=09=09=09kcalloc(nstrips,=0D=0A+=09=09=09=09=09sizeof(meta->ie[i].=
ie_strips[0]),=0D=0A+=09=09=09=09=09GFP_KERNEL);=0D=0A+=09=09=09if (!meta=
->ie[i].ie_strips) {=0D=0A+=09=09=09=09rc =3D -ENOMEM;=0D=0A+=09=09=09=09=
goto out;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09/* Inner loop is over th=
e strips */=0D=0A+=09=09=09for (j =3D 0; j < nstrips; j++) {=0D=0A+=09=09=
=09=09struct famfs_meta_simple_ext *so =3D=0D=0A+=09=09=09=09=09&meta->ie=
[i].ie_strips[j];=0D=0A+=0D=0A+=09=09=09=09so->dev_index  =3D sie_in[j].s=
e_devindex;=0D=0A+=09=09=09=09so->ext_offset =3D sie_in[j].se_offset;=0D=0A=
+=09=09=09=09so->ext_len    =3D sie_in[j].se_len;=0D=0A+=0D=0A+=09=09=09=09=
if (so->dev_index >=3D FAMFS_MAX_DAXDEVS) {=0D=0A+=09=09=09=09=09rc =3D -=
EINVAL;=0D=0A+=09=09=09=09=09goto out;=0D=0A+=09=09=09=09}=0D=0A+=09=09=09=
=09if (check_add_overflow(so->ext_offset,=0D=0A+=09=09=09=09=09=09       =
so->ext_len, &ext_end) ||=0D=0A+=09=09=09=09    check_add_overflow(extent=
_total,=0D=0A+=09=09=09=09=09=09       so->ext_len,=0D=0A+=09=09=09=09=09=
=09       &extent_total)) {=0D=0A+=09=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=
=09=09=09=09goto out;=0D=0A+=09=09=09=09}=0D=0A+=09=09=09=09meta->dev_bit=
map |=3D BIT_ULL(so->dev_index);=0D=0A+=09=09=09=09errs +=3D famfs_check_=
ext_alignment(so);=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09/*=0D=0A+=09=09=
=09 * Validate that every strip physically holds the chunks=0D=0A+=09=09=09=
 * striped onto it. Rather than trust the strip sizes,=0D=0A+=09=09=09 * =
probe the highest file offset that lands on each strip=0D=0A+=09=09=09 * =
-- the last byte of each last-stripe chunk -- and=0D=0A+=09=09=09 * resol=
ve it with the same arithmetic the fault path=0D=0A+=09=09=09 * uses. If =
those worst-case offsets resolve within their=0D=0A+=09=09=09 * strips, e=
very lower offset does too. Strips beyond the=0D=0A+=09=09=09 * chunk cou=
nt map nothing and are skipped.=0D=0A+=09=09=09 */=0D=0A+=09=09=09nprobe =
=3D min_t(u64, nstrips, chunks);=0D=0A+=09=09=09for (n =3D 0; n < nprobe;=
 n++) {=0D=0A+=09=09=09=09u64 c          =3D chunks - 1 - n;=0D=0A+=09=09=
=09=09u64 stripe_num =3D c / nstrips;=0D=0A+=09=09=09=09u64 strip_num  =3D=
 c % nstrips;=0D=0A+=09=09=09=09u64 chunk_last =3D (c =3D=3D chunks - 1) =
=3F=0D=0A+=09=09=09=09=09((ie_in->ie_nbytes - 1) %=0D=0A+=09=09=09=09=09 =
ie_in->ie_chunk_size) :=0D=0A+=09=09=09=09=09(ie_in->ie_chunk_size - 1);=0D=
=0A+=09=09=09=09u64 strip_off  =3D stripe_num *=0D=0A+=09=09=09=09=09ie_i=
n->ie_chunk_size + chunk_last;=0D=0A+=0D=0A+=09=09=09=09if (strip_off >=3D=
=0D=0A+=09=09=09=09    meta->ie[i].ie_strips[strip_num].ext_len) {=0D=0A+=
=09=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09=09goto out;=0D=0A+=09=09=
=09=09}=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09/* This interleaved extent=
 maps ie_nbytes logical bytes */=0D=0A+=09=09=09if (check_add_overflow(lo=
gical_total, ie_in->ie_nbytes,=0D=0A+=09=09=09=09=09       &logical_total=
)) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out;=0D=0A+=
=09=09=09}=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09if (logical_total < meta->fil=
e_size) {=0D=0A+=09=09=09/* Interleaved extents do not cover the whole fi=
le */=0D=0A+=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09goto out;=0D=0A+=09=09=
}=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=0D=0A+=09default:=0D=0A+=09=09rc =3D=
 -EINVAL;=0D=0A+=09=09goto out;=0D=0A+=09}=0D=0A+=0D=0A+=09if (errs > 0) =
{=0D=0A+=09=09rc =3D -EINVAL;=0D=0A+=09=09goto out;=0D=0A+=09}=0D=0A+=09i=
f (extent_total < meta->file_size) {=0D=0A+=09=09rc =3D -EINVAL;=0D=0A+=09=
=09goto out;=0D=0A+=09}=0D=0A+=0D=0A+=09/* Publish the famfs metadata on =
inode->i_private */=0D=0A+=09inode_lock(inode);=0D=0A+=09if (inode->i_pri=
vate) {=0D=0A+=09=09rc =3D -EEXIST; /* file already has famfs metadata */=
=0D=0A+=09} else {=0D=0A+=09=09inode->i_private =3D meta;=0D=0A+=09=09i_s=
ize_write(inode, meta->file_size);=0D=0A+=09=09inode->i_flags |=3D S_DAX;=
=0D=0A+=09=09meta =3D NULL; /* owned by the inode now */=0D=0A+=09=09rc =3D=
 0;=0D=0A+=09}=0D=0A+=09inode_unlock(inode);=0D=0A+=0D=0A+out:=0D=0A+=09k=
vfree(fmap_buf);=0D=0A+=09if (meta)=0D=0A+=09=09famfs_meta_free(meta);=0D=
=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_file_ioctl() - =
Top-level famfs file ioctl handler=0D=0A+ * @file: the file=0D=0A+ * @cmd=
:  ioctl opcode=0D=0A+ * @arg:  ioctl opcode argument (if any)=0D=0A+ */=0D=
=0A+static long=0D=0A+famfs_file_ioctl(struct file *file, unsigned int cm=
d, unsigned long arg)=0D=0A+{=0D=0A+=09struct inode *inode =3D file_inode=
(file);=0D=0A+=09struct famfs_fs_info *fsi =3D inode->i_sb->s_fs_info;=0D=
=0A+=09long rc;=0D=0A+=0D=0A+=09if (fsi->deverror && (cmd !=3D FAMFSIOC_N=
OP))=0D=0A+=09=09return -ENODEV;=0D=0A+=0D=0A+=09switch (cmd) {=0D=0A+=09=
case FAMFSIOC_NOP:=0D=0A+=09=09rc =3D 0;=0D=0A+=09=09break;=0D=0A+=0D=0A+=
=09case FAMFSIOC_MAP_CREATE:=0D=0A+=09=09rc =3D famfs_file_init_dax(file,=
 (void __user *)arg);=0D=0A+=09=09break;=0D=0A+=0D=0A+=09default:=0D=0A+=09=
=09rc =3D -ENOTTY;=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=0D=0A+=09return r=
c;=0D=0A+}=0D=0A+=0D=0A /************************************************=
*********************=0D=0A  * vm_operations=0D=0A  */=0D=0A@@ -94,6 +462=
,23 @@ const struct vm_operations_struct famfs_file_vm_ops =3D {=0D=0A st=
atic ssize_t=0D=0A famfs_file_invalid(struct inode *inode)=0D=0A {=0D=0A+=
=09struct famfs_file_meta *meta =3D inode->i_private;=0D=0A+=09size_t i_s=
ize =3D i_size_read(inode);=0D=0A+=0D=0A+=09if (!meta) {=0D=0A+=09=09pr_d=
ebug("%s: un-initialized famfs file\n", __func__);=0D=0A+=09=09return -EI=
O;=0D=0A+=09}=0D=0A+=09if (meta->error) {=0D=0A+=09=09pr_debug("%s: previ=
ously detected metadata errors\n", __func__);=0D=0A+=09=09return -EIO;=0D=
=0A+=09}=0D=0A+=09if (i_size !=3D meta->file_size) {=0D=0A+=09=09pr_warn(=
"%s: i_size overwritten from %ld to %ld\n",=0D=0A+=09=09       __func__, =
meta->file_size, i_size);=0D=0A+=09=09meta->error =3D true;=0D=0A+=09=09r=
eturn -ENXIO;=0D=0A+=09}=0D=0A =09if (!IS_DAX(inode)) {=0D=0A =09=09pr_de=
bug("%s: inode %llx IS_DAX is false\n",=0D=0A =09=09=09 __func__, (u64)in=
ode);=0D=0A@@ -233,7 +618,7 @@ const struct file_operations famfs_file_op=
erations =3D {=0D=0A =09/* Custom famfs operations */=0D=0A =09.write_ite=
r=09   =3D famfs_dax_write_iter,=0D=0A =09.read_iter=09   =3D famfs_dax_r=
ead_iter,=0D=0A-=09.unlocked_ioctl    =3D NULL /*famfs_file_ioctl*/,=0D=0A=
+=09.unlocked_ioctl    =3D famfs_file_ioctl,=0D=0A =09.mmap=09=09   =3D f=
amfs_file_mmap,=0D=0A=20=0D=0A =09/* Force PMD alignment for mmap */=0D=0A=
diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex 9=
e8662c4ac98..98c877a6009e 100644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+=
++ b/fs/famfs/famfs_inode.c=0D=0A@@ -341,6 +341,7 @@ famfs_show_options(s=
truct seq_file *m, struct dentry *root)=0D=0A static void=0D=0A famfs_evi=
ct_inode(struct inode *inode)=0D=0A {=0D=0A+=09famfs_meta_free((struct fa=
mfs_file_meta *)inode->i_private);=0D=0A =09inode->i_private =3D NULL;=0D=
=0A =09dax_break_layout_final(inode);=0D=0A =09truncate_inode_pages_final=
(&inode->i_data);=0D=0Adiff --git a/fs/famfs/famfs_internal.h b/fs/famfs/=
famfs_internal.h=0D=0Aindex ff9f1d3f686e..f17380d24f6d 100644=0D=0A--- a/=
fs/famfs/famfs_internal.h=0D=0A+++ b/fs/famfs/famfs_internal.h=0D=0A@@ -1=
5,8 +15,52 @@=0D=0A #include <linux/bits.h>=0D=0A #include <linux/build_b=
ug.h>=0D=0A=20=0D=0A+#include <linux/famfs_ioctl.h>=0D=0A+=0D=0A extern c=
onst struct file_operations famfs_file_operations;=0D=0A=20=0D=0A+/*=0D=0A=
+ * Internal sanity bound on a FAMFSIOC_MAP_CREATE fmap message. The ABI =
does=0D=0A+ * not advertise a maximum (the message is self-describing); t=
his only guards=0D=0A+ * the copy-in against an unreasonable allocation. =
Oversize is rejected with=0D=0A+ * -EFBIG.=0D=0A+ */=0D=0A+#define FAMFS_=
FMAP_MSG_MAX (4 * 1024 * 1024)=0D=0A+=0D=0A+struct famfs_meta_simple_ext =
{=0D=0A+=09u64 dev_index;=0D=0A+=09u64 ext_offset;=0D=0A+=09u64 ext_len;=0D=
=0A+};=0D=0A+=0D=0A+struct famfs_meta_interleaved_ext {=0D=0A+=09u64 fie_=
nstrips;=0D=0A+=09u64 fie_chunk_size;=0D=0A+=09u64 fie_nbytes;=0D=0A+=09s=
truct famfs_meta_simple_ext *ie_strips;=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ *=
 Each famfs dax file has this hanging from its inode->i_private.=0D=0A+ *=
/=0D=0A+struct famfs_file_meta {=0D=0A+=09bool                   error;=0D=
=0A+=09enum famfs_file_type   file_type;=0D=0A+=09size_t                 =
file_size;=0D=0A+=09enum famfs_ioc_ext_type fm_extent_type;=0D=0A+=09u64 =
                   dev_bitmap; /* referenced daxdev indices */=0D=0A+=09u=
nion { /* This will make code a bit more readable */=0D=0A+=09=09struct {=
=0D=0A+=09=09=09size_t         fm_nextents;=0D=0A+=09=09=09struct famfs_m=
eta_simple_ext  *se;=0D=0A+=09=09};=0D=0A+=09=09struct {=0D=0A+=09=09=09s=
ize_t         fm_niext;=0D=0A+=09=09=09struct famfs_meta_interleaved_ext =
*ie;=0D=0A+=09=09};=0D=0A+=09};=0D=0A+};=0D=0A+=0D=0A struct famfs_mount_=
opts {=0D=0A =09umode_t mode;=0D=0A };=0D=0A@@ -83,4 +127,6 @@ int famfs_=
devlist_alloc(struct famfs_fs_info *fsi);=0D=0A int famfs_install_daxdev(=
struct famfs_fs_info *fsi, struct super_block *sb,=0D=0A =09=09=09 u64 in=
dex, dev_t devno, const char *name);=0D=0A=20=0D=0A+void famfs_meta_free(=
struct famfs_file_meta *map);=0D=0A+=0D=0A #endif /* FAMFS_INTERNAL_H */=0D=
=0Adiff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/fam=
fs_ioctl.h=0D=0Anew file mode 100644=0D=0Aindex 000000000000..b4eb373c1ad=
e=0D=0A--- /dev/null=0D=0A+++ b/include/uapi/linux/famfs_ioctl.h=0D=0A@@ =
-0,0 +1,91 @@=0D=0A+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscal=
l-note */=0D=0A+/*=0D=0A+ * famfs - dax file system for shared fabric-att=
ached memory=0D=0A+ *=0D=0A+ * Copyright 2023-2024 Micron Technology, Inc=
=2E=0D=0A+ *=0D=0A+ * This file system, originally based on ramfs the dax=
 support from xfs,=0D=0A+ * is intended to allow multiple host systems to=
 mount a common file system=0D=0A+ * view of dax files that map to shared=
 memory.=0D=0A+ */=0D=0A+#ifndef FAMFS_IOCTL_H=0D=0A+#define FAMFS_IOCTL_=
H=0D=0A+=0D=0A+#include <linux/ioctl.h>=0D=0A+#include <linux/uuid.h>=0D=0A=
+=0D=0A+#define FAMFS_KABI_VERSION 44=0D=0A+=0D=0A+enum famfs_file_type {=
=0D=0A+=09FAMFS_REG,=0D=0A+=09FAMFS_SUPERBLOCK,=0D=0A+=09FAMFS_LOG,=0D=0A=
+};=0D=0A+=0D=0A+/*=0D=0A+ * Extent type in a famfs fmap message, and of =
the in-core map=0D=0A+ * (famfs_file_meta.fm_extent_type).=0D=0A+ */=0D=0A=
+enum famfs_ioc_ext_type {=0D=0A+=09FAMFS_IOC_EXT_SIMPLE,=0D=0A+=09FAMFS_=
IOC_EXT_INTERLEAVE,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * The FAMFSIOC_MAP_CR=
EATE payload is a self-describing fmap message: a=0D=0A+ * struct famfs_i=
oc_fmap_header immediately followed by @nextents extent=0D=0A+ * records.=
 @fmap_size gives the total message length, so a reader is=0D=0A+ * self-=
delimiting.=0D=0A+ *=0D=0A+ * For ext_type =3D=3D FAMFS_IOC_EXT_SIMPLE th=
e records are an array of=0D=0A+ * @nextents famfs_ioc_simple_ext. For ex=
t_type =3D=3D FAMFS_IOC_EXT_INTERLEAVE=0D=0A+ * each of the @nextents rec=
ords is a famfs_ioc_iext header immediately=0D=0A+ * followed by ie_nstri=
ps famfs_ioc_simple_ext strip extents.=0D=0A+ *=0D=0A+ * This wire layout=
 is byte-identical to the fmap carried in a fuse famfs=0D=0A+ * GET_FMAP =
reply, so the same userspace serializer emits both.=0D=0A+ *=0D=0A+ * The=
 message is self-describing (@fmap_size bounds it), so neither the extent=
=0D=0A+ * and strip counts nor the total size are capped by this ABI. The=
 kernel=0D=0A+ * applies an internal sanity limit to the copy-in and retu=
rns -EFBIG for a=0D=0A+ * message larger than it will accept.=0D=0A+ */=0D=
=0A+#define FAMFS_FMAP_VERSION 1=0D=0A+=0D=0A+struct famfs_ioc_simple_ext=
 {=0D=0A+=09__u32 se_devindex;=0D=0A+=09__u32 reserved;=0D=0A+=09__u64 se=
_offset;=0D=0A+=09__u64 se_len;=0D=0A+};=0D=0A+=0D=0A+struct famfs_ioc_ie=
xt {=09=09/* interleaved (striped) extent */=0D=0A+=09__u32 ie_nstrips;=0D=
=0A+=09__u32 ie_chunk_size;=0D=0A+=09__u64 ie_nbytes;=09/* total bytes ma=
pped by this interleaved extent */=0D=0A+=09__u64 reserved;=0D=0A+};=0D=0A=
+=0D=0A+struct famfs_ioc_fmap_header {=0D=0A+=09__u8  file_type;=09/* enu=
m famfs_file_type */=0D=0A+=09__u8  reserved;=0D=0A+=09__u16 fmap_version=
;=09/* FAMFS_FMAP_VERSION */=0D=0A+=09__u32 ext_type;=09=09/* enum famfs_=
ioc_ext_type */=0D=0A+=09__u32 nextents;=0D=0A+=09__u32 fmap_size;=09/* t=
otal message bytes, including this header */=0D=0A+=09__u64 file_size;=0D=
=0A+=09__u64 reserved1;=0D=0A+};=0D=0A+=0D=0A+#define FAMFSIOC_MAGIC 'u'=0D=
=0A+=0D=0A+/* famfs file ioctl opcodes */=0D=0A+#define FAMFSIOC_NOP     =
      _IO(FAMFSIOC_MAGIC,   0x50)=0D=0A+=0D=0A+/*=0D=0A+ * MAP_CREATE car=
ries the self-describing fmap message - struct=0D=0A+ * famfs_ioc_fmap_he=
ader followed by the extent list (see above).=0D=0A+ */=0D=0A+#define FAM=
FSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC,  0x51, struct famfs_ioc_fmap_hea=
der)=0D=0A+=0D=0A+#endif /* FAMFS_IOCTL_H */=0D=0A--=20=0D=0A2.53.0=0D=0A=
=0D=0A
