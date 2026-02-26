Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1738D39448D;
	Thu, 26 Feb 2026 21:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772139999; cv=none; b=puHId4VBaLOdGmb+WlEd7WY2Mvt144csdRJ80M2R5iYnJ36VXtMeWE1MHneP2525Hp/Vc1U/ZEedcPjB8Qihzl/BAlvPhqdkhaDe2sOOEyxWymo2TbKdS6nFUQ0VbmlZlT/mT44eVtcHGlbvsdCjdLu68QPx18zzWGeTkJs3ams=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772139999; c=relaxed/simple;
	bh=CQG6cerFtYv/0ee9CKn8UQrC/xKUsT6OPLVfmy6FJz8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=MkRWtJnYSWxGdh/MxwRYIu0quIPl2c3boHqspOVMHMXLVBxuG6wONPhW+XKZUHjwNjmJsQugUKkyMn1o27P8mfmUx2+3hXcdi0Xu+VwEuRr02ioDao999UN9gU1agJySq1nDCS1L4zBK0WxeOfI7+U3PwNvyS2bDqVAu+fZRS10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 325382A3C71;
	Thu, 26 Feb 2026 22:06:35 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id wtNVnsVrigfw; Thu, 26 Feb 2026 22:06:33 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 3D6F329ABD6;
	Thu, 26 Feb 2026 22:06:33 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TTBOxwOFVdGm; Thu, 26 Feb 2026 22:06:32 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id EFF89298599;
	Thu, 26 Feb 2026 22:06:31 +0100 (CET)
Date: Thu, 26 Feb 2026 22:06:31 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: Jeff Layton <jlayton@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	mhiramat <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	dan j williams <dan.j.williams@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, 
	Eric Biggers <ebiggers@kernel.org>, tytso <tytso@mit.edu>, 
	Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, anna <anna@kernel.org>, 
	chuck lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Steve French <sfrench@samba.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Alexander Aring <alex.aring@gmail.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, 
	Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, 
	David Sterba <dsterba@suse.com>, 
	Marc Dionne <marc.dionne@auristor.com>, raven <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>, 
	coda@cs.cmu.edu, Nicolas Pitre <nico@fluxnic.net>, 
	Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	David Woodhouse <dwmw2@infradead.org>, 
	Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
	chengzhihao1 <chengzhihao1@huawei.com>, 
	Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, 
	John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, 
	Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	sumit semwal <sumit.semwal@linaro.org>, 
	edumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, pabeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, davem <davem@davemloft.net>, 
	kuba <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	oleg <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	mingo <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, 
	Martin Schiller <ms@dev.tdt.de>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>, 
	nvdimm@lists.linux.dev, fsverity@lists.linux.dev, 
	linux-mm <linux-mm@kvack.org>, netfs@lists.linux.dev, 
	linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>, 
	linux-nfs <linux-nfs@vger.kernel.org>, 
	linux-cifs <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, 
	linux-nilfs <linux-nilfs@vger.kernel.org>, 
	v9fs <v9fs@lists.linux.dev>, 
	linux-afs <linux-afs@lists.infradead.org>, autofs@vger.kernel.org, 
	ceph-devel <ceph-devel@vger.kernel.org>, codalist@coda.cs.cmu.edu, 
	ecryptfs <ecryptfs@vger.kernel.org>, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	jfs-discussion <jfs-discussion@lists.sourceforge.net>, 
	ntfs3 <ntfs3@lists.linux.dev>, 
	ocfs2-devel <ocfs2-devel@lists.linux.dev>, 
	devel <devel@lists.orangefs.org>, 
	linux-unionfs <linux-unionfs@vger.kernel.org>, 
	apparmor@lists.ubuntu.com, 
	LSM <linux-security-module@vger.kernel.org>, 
	linux-integrity <linux-integrity@vger.kernel.org>, 
	selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	DRI mailing list <dri-devel@lists.freedesktop.org>, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	netdev <netdev@vger.kernel.org>, linux-perf-users@vger.kernel.org, 
	linux-fscrypt <linux-fscrypt@vger.kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org
Message-ID: <1889140340.1973.1772139991688.JavaMail.zimbra@nod.at>
In-Reply-To: <20260226-iino-u64-v1-37-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org> <20260226-iino-u64-v1-37-ccceff366db9@kernel.org>
Subject: Re: [PATCH 37/61] jffs2: update format strings for u64 i_ino
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF147 (Linux)/8.8.12_GA_3809)
Thread-Topic: jffs2: update format strings for u64 i_ino
Thread-Index: xD7TK6/dJ7pUGRHHehUamcKvWNrpNA==

----- Urspr=C3=BCngliche Mail -----
> Von: "Jeff Layton" <jlayton@kernel.org>
> Update format strings and local variable types in jffs2 for the
> i_ino type change from unsigned long to u64.
>=20
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> fs/jffs2/dir.c  |  4 ++--
> fs/jffs2/file.c |  4 ++--
> fs/jffs2/fs.c   | 18 +++++++++---------
> 3 files changed, 13 insertions(+), 13 deletions(-)

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
