Received: from a48-182.smtp-out.amazonses.com (a48-182.smtp-out.amazonses.com [54.240.48.182])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB3D2F3C3D;
	Mon,  3 Aug 2026 02:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724065; cv=none; b=P8hr/L4H4galc8fuT3wumktyrbbHzfqnHbNe6vAN7wj23Vts0U4/hd2cXhG0gFJcS3ClLHmKGpAcZQ6jxnVZpxAQYWWZ+xAp6NdS43dqVWvT5p+34MGWQHAaIUL4CZ0/r8pFu50PJo3Efs0poVIpDopg8tWWAT6WZ5Ir1m/bmes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724065; c=relaxed/simple;
	bh=lbJoab6fAJTi3t+dA326ywexQxFLguZg0ti68aNMw+w=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=phGsDvKODcrz8RqIKcbHlZXmrLahqhIyZDg5KmkQsp7gPVinMd9trDzqcwZlifh3mYpm1Vb3MODwAx1W332LHUYueZnn011mx4N8J9jNLS5d04RUHLn890T1s2RettASIV1rz2w3SarxmhGMuyhOS/p1Xn+uqs9fi2j7VK+doS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=n30Fvs9N; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=ruJgRKPX; arc=none smtp.client-ip=54.240.48.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="n30Fvs9N";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ruJgRKPX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1785724062;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=lbJoab6fAJTi3t+dA326ywexQxFLguZg0ti68aNMw+w=;
	b=n30Fvs9NRPRNBNau6iC3czEBwmvfltZqLF5OnXYR4x68gix8iPdP4Yfb50uwUuTo
	AVccpZYVS9/obdg0O2O9ScGwB8hoTLlDE0gGOjUJYAQPy7JNnXvu51MmqsGzKJ37Vll
	y3cWFwfm4gcroQ/XpncrtwRtwRQLX0sLfzeGfi2Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1785724062;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=lbJoab6fAJTi3t+dA326ywexQxFLguZg0ti68aNMw+w=;
	b=ruJgRKPX6mEeKteCjmXd/ZmbSMJSvJkNIbwYXSGVpX0Yrm3MVH654Su1sW/XY8V4
	A9CAiKoSl+xk/Nhyjan0idsLfIh98nD7KIOTpLxak5jxdtZYR1w0LCG8X0ClWCuV2jZ
	nSYvW2gMOxwjoCQAq+ZmUtF73kcQqdMoGM73gZpA=
Subject: [PATCH V12 00/12] famfs: the Fabric-Attached Memory File System
 (standalone)
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
Date: Mon, 3 Aug 2026 02:27:42 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260803022730.75731-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdIu+ovgpm4enMRRGNw8yF9Kn6iw==
Thread-Topic: [PATCH V12 00/12] famfs: the Fabric-Attached Memory File System
 (standalone)
X-Wm-Sent-Timestamp: 1785724061
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.03-54.240.48.182

From: John Groves <john@groves.net>=0D=0A=0D=0AThis patch series introduc=
es famfs as a standalone file system, as a pivot=0D=0Aback from fuse/libf=
use, for which the porting effort took close to a year, but=0D=0Athen the=
 review effort started with almost a yearlong delay, and then got=0D=0Ame=
ssy :D [3].=0D=0A=0D=0AHowever, after years of maintaining famfs in both =
forms (standalone and fuse -=0D=0Athe famfs user space works with both) I=
 think famfs makes more sense as a=0D=0Astandalone file system - and some=
 influential maintainers have privately=0D=0Aexpressed that opinion to me=
=2E=0D=0A=0D=0AThe most important thing to know about famfs is that it CA=
NNOT be used as a=0D=0Ageneral purpose file system. It is for enabling fi=
le-based byte-level access=0D=0A(including direct mmap) to very large (e.=
g. 100TB) shared/disaggregated=0D=0Amemory appliances - which have become=
 available during this long process,=0D=0Aand which are in need of Linux =
support.=0D=0A=0D=0ASo famfs cannot be used by anybody who doesn't know w=
hy they need it; Making=0D=0Afamfs standalone means it can't affect users=
 who don't use it. And my super-=0D=0Amega-corp employer (Micron), as wel=
l as other memory companies, need it.=0D=0AWe do not intend to abandon it=
, but imagine if we did: fs/famfs/ should be=0D=0Aremoved if the memory c=
ompanies can't be bothered to maintain it.=0D=0A=0D=0AThis code base has =
been in active CI and used globally by early adopters and=0D=0Atesters of=
 disaggregated memory. I believe it is solid.=0D=0A=0D=0AHistory (skip if=
 you lived it like I did :D)=0D=0A=0D=0AFamfs was introduced at LPC 2023 =
and LSFMM 2024 [1] as a standalone file=0D=0Asystem. The fuse odyssey sta=
rted at LSFMM 24, but I think it's time to=0D=0Abring that to a close. Th=
e first fuse/libfuse patches came out in April=0D=0A2025 [2] - adding a s=
ubstantial amount of complexity to the famfs user space,=0D=0Aand controv=
ersial complexity to fuse [3].=0D=0A=0D=0AThe fuse community was uncomfor=
table with the new metadata and fuse message=0D=0Aformats that famfs need=
s, going so far as to suggest that famfs use a BPF=0D=0Aprogram as a vma =
fault handler [3] to avoid the need to pass famfs file=0D=0Ametadata via =
fuse messages - an idea which, to my relief, was definitively=0D=0Ashot d=
own at LSFMM 2026 [4].=0D=0A=0D=0AIn that session, I was preparing to mak=
e the pivot-to-standalone argument,=0D=0Aand there were others in the roo=
m who support that - but Miklos stated that=0D=0Ahe was not opposed to me=
rging famfs as it stands [4], leading me to back off=0D=0Aof the standalo=
ne pivot at the time.=0D=0A=0D=0AHowever, 1) that is not how the recent p=
atch discussions have been going [5],=0D=0Aand 2) I have (not solely on t=
hat basis) come to the conclusion that famfs=0D=0Amakes more sense as a s=
tandalone entity. In v11 [5] I dropped the=0D=0Acontroversial famfs inter=
leaved extent (exploding fmaps from well under a=0D=0Apage to megabytes),=
 and there is still a push for adding an intermediate=0D=0Avirtual backin=
g dev layer that famfs does not need and can't really live=0D=0Awith. I c=
ould go on...=0D=0A=0D=0AMy argument=0D=0A=0D=0ACan we make famfs work in=
 fuse=3F Yes, if we can agree some things that have=0D=0Abeen quite chall=
enging to agree on. Should we=3F I think not.=0D=0A=0D=0AI think famfs ad=
ds complexity to fuse that will not likely see constructive=0D=0Are-use. =
And I think fuse makes famfs worse - significantly more complex, less=0D=0A=
adaptable to change, and less performant. And famfs files are memory - ac=
cess=0D=0Aneeds to run at memory speeds! In short the risks out-weigh the=
 benefits.=0D=0A=0D=0AAbout this patch series=0D=0A=0D=0AI've called it V=
12 for recent continuity; there was a V1 and a V2 standalone=0D=0Ain 2024=
, and then V1-V11 were fuse (call this selective consistency).=0D=0A=0D=0A=
Famfs depends on the 'fsdev' dax mode which landed in 7.1 - it will only =
run=0D=0Awith an fsdev-mode (aka famfs-mode) daxdev as its backing device=
(s).=0D=0A=0D=0APatch 01 is a fix to the fsdev driver that is needed by t=
he rest of the=0D=0Aseries.=0D=0A=0D=0AFamfs Overview=0D=0A=0D=0AFamfs ex=
poses sharable disaggregated memory as a file system. Famfs consumes=0D=0A=
shared memory from [usually shared memory] dax devices, and provides=0D=0A=
memory-mappable files that map directly to the memory - no page cache=0D=0A=
involvement. Famfs differs from conventional file systems in fs-dax mode,=
=0D=0Ain that it handles in-memory metadata in a sharable way (which begi=
ns with=0D=0Anever caching dirty shared metadata). So a famfs file system=
 can be mounted=0D=0Afrom multiple nodes, provided they have access to th=
e memory.=0D=0A=0D=0AThe key performance requirement is that famfs must r=
esolve mapping=0D=0Afaults with minimal overhead. This is achieved by ful=
ly caching the=0D=0Afile-to-devdax metadata for all active files.=0D=0A=0D=
=0AFamfs remains the first fs-dax file system that is backed by devdax=0D=
=0Arather than pmem in fs-dax mode (hence the need for the new dax mode).=
=0D=0A=0D=0AThe famfs user space can be found at [6]=0D=0A=0D=0A[1] https=
://lwn.net/Articles/983105/ (Famfs at LSFMM 2024)=0D=0A[2] https://lwn.ne=
t/Articles/1020170/ (Famfs at LSFMM 2025, with patch link)=0D=0A[3] https=
://lwn.net/Articles/1068686/ (LWN coverage of the patch thread)=0D=0A[4] =
https://lwn.net/Articles/1082687/ (Famfs at LSFMM 2026)=0D=0A[5] https://=
lore.kernel.org/linux-fsdevel/0100019f7d9fbe81-6cb16662-2522-47ea-a152-fa=
b0ee3d9b35-000000@email.amazonses.com/#b=0D=0A[6] https://famfs.org=0D=0A=
=0D=0AJohn Groves (12):=0D=0A  dax: replace exported dax_dev_get() with n=
on-allocating dax_dev_find()=0D=0A  famfs: Module operations, fs_context,=
 and mount=0D=0A  famfs: Add daxdev table and dax notify_failure support=0D=
=0A  famfs: Introduce inode_operations and super_operations=0D=0A  famfs:=
 Introduce file_operations read/write=0D=0A  famfs: Introduce mmap and VM=
 fault handling=0D=0A  famfs: MAP_CREATE ioctl and fmap ingest (ABI 44)=0D=
=0A  famfs: iomap_begin and file-to-dax offset resolution=0D=0A  famfs: R=
egister secondary daxdevs by path (FAMFSIOC_DAXDEV_OPEN)=0D=0A  famfs: Ad=
d runtime operation-permission (opts) framework=0D=0A  famfs: Report devi=
ce capacity via statfs so df works=0D=0A  famfs: Add documentation=0D=0A=0D=
=0A Documentation/filesystems/famfs.rst           | 142 +++=0D=0A Documen=
tation/filesystems/index.rst           |   1 +=0D=0A .../userspace-api/io=
ctl/ioctl-number.rst      |   1 +=0D=0A MAINTAINERS                      =
             |   8 +=0D=0A drivers/dax/fsdev.c                           =
|  19 +=0D=0A drivers/dax/super.c                           |  38 +-=0D=0A=
 fs/Kconfig                                    |   2 +=0D=0A fs/Makefile =
                                  |   1 +=0D=0A fs/famfs/Kconfig         =
                     |  11 +=0D=0A fs/famfs/Makefile                     =
        |   5 +=0D=0A fs/famfs/famfs_file.c                         | 983=
 ++++++++++++++++++=0D=0A fs/famfs/famfs_inode.c                        |=
 813 +++++++++++++++=0D=0A fs/famfs/famfs_internal.h                     =
| 162 +++=0D=0A fs/namei.c                                    |   1 +=0D=0A=
 fs/super.c                                    |   7 +=0D=0A include/linu=
x/dax.h                           |   7 +-=0D=0A include/linux/fs.h      =
                      |   1 +=0D=0A include/uapi/linux/famfs_ioctl.h     =
         | 160 +++=0D=0A include/uapi/linux/magic.h                    | =
  1 +=0D=0A 19 files changed, 2360 insertions(+), 3 deletions(-)=0D=0A cr=
eate mode 100644 Documentation/filesystems/famfs.rst=0D=0A create mode 10=
0644 fs/famfs/Kconfig=0D=0A create mode 100644 fs/famfs/Makefile=0D=0A cr=
eate mode 100644 fs/famfs/famfs_file.c=0D=0A create mode 100644 fs/famfs/=
famfs_inode.c=0D=0A create mode 100644 fs/famfs/famfs_internal.h=0D=0A cr=
eate mode 100644 include/uapi/linux/famfs_ioctl.h=0D=0A=0D=0A--=20=0D=0A2=
=2E53.0=0D=0A=0D=0A
