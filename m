Received: from a11-75.smtp-out.amazonses.com (a11-75.smtp-out.amazonses.com [54.240.11.75])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9B83955C8;
	Mon, 20 Jul 2026 03:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519141; cv=none; b=dw2WMt/NB5YPvZQkNMCoPdoSs4DUPzIixzyRVB+l2671z5M2ROg1K+Pn/6zXKekY9A5XztoWfB/RUzGHCNHk919KazkZp6Gomsd6IwGNBjd+RsZBxHI6Snh2oF2u9ZTQgMnD0UTHsV+mKKWk1EdE8HARORg/NgEnDvYDScgj61A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519141; c=relaxed/simple;
	bh=nSRrL5XDRlPM055WDqVmDEpHr38cQMpb9OlH2k28gUc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=NBmghwA3rcvi5Uosgyyx3v/2j4Gi58Z9/ddsd3KXeh6/wfdPouo0ULYOi650vYRwZMIhbforbRPlqKAV+YhaIV3cEBd57pl/0tPCpknOQT4Hes1u8FsGqyaKNrY+7gjOKHWru21DM0BVnP91qEmStEf4lFl8tK/J1ONQqhGtEZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=PxCYB+DN; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=QZYka99/; arc=none smtp.client-ip=54.240.11.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="PxCYB+DN";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="QZYka99/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1784519139;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=nSRrL5XDRlPM055WDqVmDEpHr38cQMpb9OlH2k28gUc=;
	b=PxCYB+DNIZK1ku1AssEg3sd4XvDRxRTKvCWHpr2oeU7bQ6LmuqYbrzvDSA9Rzcqs
	2LvX2SgUBEMBwPGMMJ7sfP+d6SnU4H+lR2N5UDdZA6M+m09ZtwzzNc7j5bsnHGqiy65
	w+lBG7/t3Ij63/pzCKCxh8moaBrPcaj7MrpCtth8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1784519139;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=nSRrL5XDRlPM055WDqVmDEpHr38cQMpb9OlH2k28gUc=;
	b=QZYka99/LV3/PAWcguMSqbdYhaNQpEW0+pXPlVRqroDSDQCYhwXK2gq4A2LN3V/A
	LhnWbDwt70pPPgUNPy2dEfLcS4ljTa5KOpv8RfXSH5mjxPZObV9KxPtNEKkX9IZ4QUt
	LyhzA8AINY6n9V5M5Wm/RVTnv+T2CjYvLZgVW8XY=
Subject: [PATCH V11 2/9] famfs_fuse: Basic fuse kernel ABI enablement for
 famfs
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
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
	=?UTF-8?Q?Jonathan_Cameron?= <Jonathan.Cameron@huawei.com>, 
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
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2E?= =?UTF-8?Q?org?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2E?= =?UTF-8?Q?linux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40v?= =?UTF-8?Q?ger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?fuse-devel=40lists=2Elinux=2E?= =?UTF-8?Q?dev?= <fuse-devel@lists.linux.dev>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 20 Jul 2026 03:45:39 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
References: 
 <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com> 
 <20260720034532.68759-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdF/oEAFJtLKnZRyOlO7hUjUgWYwAADX9H
Thread-Topic: [PATCH V11 2/9] famfs_fuse: Basic fuse kernel ABI enablement
 for famfs
X-Wm-Sent-Timestamp: 1784519137
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019f7da11f42-c1026097-89e3-4a44-93d0-ef0938544d6b-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.07.20-54.240.11.75

From: John Groves <john@groves.net>=0D=0A=0D=0AAdd the minimal fuse plumb=
ing that later famfs commits build on:=0D=0A=0D=0A- Kconfig: add FUSE_FAM=
FS_DAX to control compilation of famfs support=0D=0A  within fuse.=0D=0A-=
 uapi: add the FUSE_DAX_FMAP flag for the INIT request/reply, by which=0D=
=0A  the server and kernel negotiate famfs (in-kernel fs-dax map) support=
=2E=0D=0A- fuse_conn->famfs_iomap to mark a famfs-enabled connection.=0D=0A=
=0D=0AReviewed-by: Joanne Koong <joannelkoong@gmail.com>=0D=0AReviewed-by=
: Dave Jiang <dave.jiang@intel.com>=0D=0ASigned-off-by: John Groves <john=
@groves.net>=0D=0A---=0D=0A fs/fuse/Kconfig           | 13 +++++++++++++=0D=
=0A fs/fuse/fuse_i.h          |  3 +++=0D=0A fs/fuse/inode.c           | =
 6 ++++++=0D=0A include/uapi/linux/fuse.h |  5 +++++=0D=0A 4 files change=
d, 27 insertions(+)=0D=0A=0D=0Adiff --git a/fs/fuse/Kconfig b/fs/fuse/Kco=
nfig=0D=0Aindex 3a4ae632c94a..17fe1f490cbd 100644=0D=0A--- a/fs/fuse/Kcon=
fig=0D=0A+++ b/fs/fuse/Kconfig=0D=0A@@ -76,3 +76,16 @@ config FUSE_IO_URI=
NG=0D=0A=20=0D=0A =09  If you want to allow fuse server/client communicat=
ion through io-uring,=0D=0A =09  answer Y=0D=0A+=0D=0A+config FUSE_FAMFS_=
DAX=0D=0A+=09bool "FUSE support for fs-dax filesystems backed by devdax"=0D=
=0A+=09depends on FUSE_FS=0D=0A+=09depends on DEV_DAX_FSDEV=0D=0A+=09defa=
ult FUSE_FS=0D=0A+=09help=0D=0A+=09  This enables the fabric-attached mem=
ory file system (famfs),=0D=0A+=09  which enables formatting devdax memor=
y as a file system. Famfs=0D=0A+=09  is primarily intended for scale-out =
shared access to=0D=0A+=09  disaggregated memory.=0D=0A+=0D=0A+=09  To en=
able famfs or other fuse/fs-dax file systems, answer Y=0D=0Adiff --git a/=
fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h=0D=0Aindex f450194e877f..9c354118c931=
 100644=0D=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fuse/fuse_i.h=0D=0A@@ -=
711,6 +711,9 @@ struct fuse_conn {=0D=0A =09/** @sync_init: Is synchronou=
s FUSE_INIT allowed=3F */=0D=0A =09unsigned int sync_init:1;=0D=0A=20=0D=0A=
+=09/** @famfs_iomap: dev_dax_iomap support for famfs */=0D=0A+=09unsigne=
d int famfs_iomap:1;=0D=0A+=0D=0A =09/** @max_stack_depth: Maximum stack =
depth for passthrough backing files */=0D=0A =09int max_stack_depth;=0D=0A=
=20=0D=0Adiff --git a/fs/fuse/inode.c b/fs/fuse/inode.c=0D=0Aindex 77c21b=
28b6fa..c347471d04b6 100644=0D=0A--- a/fs/fuse/inode.c=0D=0A+++ b/fs/fuse=
/inode.c=0D=0A@@ -1406,6 +1406,10 @@ static void process_init_reply(struc=
t fuse_args *args, int error)=0D=0A=20=0D=0A =09=09=09if (flags & FUSE_RE=
QUEST_TIMEOUT)=0D=0A =09=09=09=09timeout =3D arg->request_timeout;=0D=0A+=
=0D=0A+=09=09=09if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&=0D=0A+=09=09=09 =
   flags & FUSE_DAX_FMAP)=0D=0A+=09=09=09=09fc->famfs_iomap =3D 1;=0D=0A =
=09=09} else {=0D=0A =09=09=09ra_pages =3D fc->max_read / PAGE_SIZE;=0D=0A=
 =09=09=09fc->no_lock =3D 1;=0D=0A@@ -1473,6 +1477,8 @@ static struct fus=
e_init_args *fuse_new_init(struct fuse_mount *fm)=0D=0A =09=09flags |=3D =
FUSE_SUBMOUNTS;=0D=0A =09if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))=0D=0A =09=
=09flags |=3D FUSE_PASSTHROUGH;=0D=0A+=09if (IS_ENABLED(CONFIG_FUSE_FAMFS=
_DAX))=0D=0A+=09=09flags |=3D FUSE_DAX_FMAP;=0D=0A=20=0D=0A =09/*=0D=0A =09=
 * This is just an information flag for fuse server. No need to check=0D=0A=
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h=0D=0Ai=
ndex c13e1f9a2f12..25686f088e6a 100644=0D=0A--- a/include/uapi/linux/fuse=
=2Eh=0D=0A+++ b/include/uapi/linux/fuse.h=0D=0A@@ -240,6 +240,9 @@=0D=0A =
 *  - add FUSE_COPY_FILE_RANGE_64=0D=0A  *  - add struct fuse_copy_file_r=
ange_out=0D=0A  *  - add FUSE_NOTIFY_PRUNE=0D=0A+ *=0D=0A+ *  7.46=0D=0A+=
 *  - Add FUSE_DAX_FMAP capability - ability to handle in-kernel fsdax ma=
ps=0D=0A  */=0D=0A=20=0D=0A #ifndef _LINUX_FUSE_H=0D=0A@@ -448,6 +451,7 @=
@ struct fuse_file_lock {=0D=0A  * FUSE_OVER_IO_URING: Indicate that clie=
nt supports io-uring=0D=0A  * FUSE_REQUEST_TIMEOUT: kernel supports timin=
g out requests.=0D=0A  *=09=09=09 init_out.request_timeout contains the t=
imeout (in secs)=0D=0A+ * FUSE_DAX_FMAP: kernel supports dev_dax_iomap (a=
ka famfs) fmaps=0D=0A  */=0D=0A #define FUSE_ASYNC_READ=09=09(1 << 0)=0D=0A=
 #define FUSE_POSIX_LOCKS=09(1 << 1)=0D=0A@@ -495,6 +499,7 @@ struct fuse=
_file_lock {=0D=0A #define FUSE_ALLOW_IDMAP=09(1ULL << 40)=0D=0A #define =
FUSE_OVER_IO_URING=09(1ULL << 41)=0D=0A #define FUSE_REQUEST_TIMEOUT=09(1=
ULL << 42)=0D=0A+#define FUSE_DAX_FMAP=09=09(1ULL << 43)=0D=0A=20=0D=0A /=
**=0D=0A  * CUSE INIT request/reply flags=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=
=0A
