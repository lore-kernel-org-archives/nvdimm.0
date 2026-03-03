Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9CD282F0A
	for <nvdimm@lists.linux.dev>; Tue,  3 Mar 2026 01:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501299; cv=none; b=hfFoxNqCfl1MZPJuKS6V9vFF6d7kzd3QzviAAbBBcRFEW/rwnk3t8H+cvyzbm4r33WtaEI9nTQjT+g5FS4Djjsrkrd6ootE8o9RfH+zeZr/oYUjdZUEMqxOsT7mwfDalM1OPjRns1v7yZllvn0ul1x/L4UJbzRYaj/J/hWYbBU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501299; c=relaxed/simple;
	bh=g+VdGlVLVkH1poZKLQaU9Z6Cz1tsg2GNZN6MfKpgxB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvnDrXTMgI1EEZtSBMgdHizSrSpYHyxzeNoFX3lq3+mdd+Ud79WBeDRmrngewdckuhpMedBT2bGmusx2SFrRVrruc2ukVtyDKfWixNIr+fpHx2E72BMGSBjCzODk65has50KMtAUKrqJwMERcA+cEdt/C5qprXcrvQbouZIuZrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Ev6ld9VE; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Ev6ld9VE"
Received: from macsyma.thunk.org (pool-173-48-102-84.bstnma.fios.verizon.net [173.48.102.84])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6231PuHh026611
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 2 Mar 2026 20:25:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1772501165; bh=/4PzqDjQa596+Pxv5nyCAFN8lvFTxej9AhTZolOU+To=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Ev6ld9VELfSTilMsdvuAuUcsoGxAWkhkYbGJgxub8uYi6JxNzIKpWtMLYSH65Q11a
	 LTgb4BMMz6Ut329yS0fdzL3wx8BHwrzl2QmBbUi2AkAdU/lHnsfaIHc/p6xNdd+Wna
	 Kr3z8miEjeR4glowkQniiW1V7ISWUhY5fmWVfihMm5VxA6SkKeku6+zbP1T9VwFBKQ
	 /5tsaXToc7QUEPpds9mL/NiU4uDpJ5GlCTl+veDU984lE468Lsiu54ib1lO8WnZhtt
	 A57VlXyYuMZkd5JTeNCMIbfzi9Fgy5IJlNHQH8JAeRIzB3rUV81721ZRGH+7y7rqyi
	 u4HI27iqLCxeA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 33A7D5AC5A1E; Mon,  2 Mar 2026 20:25:56 -0500 (EST)
Date: Mon, 2 Mar 2026 20:25:56 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Paulo Alcantara <pc@manguebit.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
        Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
        Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Sterba <dsterba@suse.com>,
        Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yangtao Li <frank.li@vivo.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        James Clark <james.clark@linaro.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>,
        Eric Paris <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
        fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
        v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
        autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
        codalist@telemann.coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
        linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
        ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
        devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
        apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-x25@vger.kernel.org,
        audit@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
Message-ID: <20260303012556.GA6520@macsyma-wired.lan>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>

On Mon, Mar 02, 2026 at 03:23:45PM -0500, Jeff Layton wrote:
> The PRIino macro is a length modifier, not a complete format specifier.
> It is used as: "%" PRIino "u" for decimal, "%" PRIino "x" for hex, etc.
> This follows the pattern used by userspace PRIu64/PRIx64 macros.

For the record, I really hate the inttypes.h format specifiers, but I
agree that we should forward the example of the C99 spec, for better
or for worse.

That being said, the userspace PRIu64, et. al macros are complete
format specifiers, not just a length modifier.  And I think this
results in less ugly format specifiers in our kernel code.

---- cut here ---
#!/bin/sh
cat <<EOF > /tmp/blah.c
#include <inttypes.h>
#include <stdio.h>

int main(int arg, char **argv)
{
        printf("PRIu64 is %s\n", PRIu64);
        printf("PRId64 is %s\n", PRId64);
        printf("PRIx64 is %s\n", PRIx64);
        return 0;
}
EOF

clang -m32 -o /tmp/blah /tmp/blah.c
/tmp/blah
---- cut here ---

% /tmp/blah.sh
PRIu64 is llu
PRId64 is lld
PRIx64 is llx

Thanks!

						- Ted
