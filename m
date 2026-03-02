Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7525342511
	for <nvdimm@lists.linux.dev>; Mon,  2 Mar 2026 23:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772495108; cv=pass; b=KRZx/jK2v7sz34gnMGjaUaYgf5fmqhG1Gccdcc9wzBWfwUrSIHWqzpcUW+aVlBmGtfRgaVzmxR1J5GzaXM4BjUxUqYpNOSFYu0kkFcEaV9zO2JmQn16BqZLGDNIpjgl+8I64GmhIOhyUV5odW48DLuDG2WRn+SXAV38MFeEq+7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772495108; c=relaxed/simple;
	bh=gI6mzU+h6MF7rNPJ4817XIF1lxMBARF2p+anpiUg0wA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ElYJNC7rfMvNllK/OJSMGdFb2VQ9HHY6DApAdXPcYhwfaL9BJDuhwEJvLNd0CauWuMFWbdcDeZs1KcIrzqdGmhaGr2NgF+YuGJqPjFyW6bqSrpbDFbYPzK6WDDsgHuqhYeWxhZaGfGB8Lyc8RmCF4qzYM9mQsNYfLHKXasoswVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=dKur1WsN; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="dKur1WsN"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c6e77ace76aso1895324a12.3
        for <nvdimm@lists.linux.dev>; Mon, 02 Mar 2026 15:45:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772495103; cv=none;
        d=google.com; s=arc-20240605;
        b=XuRx3mAOSsOxoeK75+drfTMcmZfWBGEL4UG8X3SW+jk+zlCnLasD+YNk3aIsSHV3Mo
         tgDp7uxcXx5EaMQLbPzjWhb94SLCxRLv4h6g2L84jkXbCyCm1j12qENdITobB3N3n6aa
         2tZKd8gd7ijVHAgHgivReEMgXRMFYYk/xyAVa7SiLrh8+zH0LFxPwKGhKLwV5vORjiwN
         Zk49SrbC1cBhLWTH4s33bc2oLZGZ/Ymg8wXamRs1Zb0vT5sy/xu//DrYFxcZNV6XWTIe
         2E15fNqAvmmn07Kd1MjImTyoe0RZV1Pq9xLNyiWKrMqzbzcFqatNcLF0ZUNy8WXDm7Z7
         banQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u082M2vpZx7MrZkmV/F7ZdAH+CJQSjxHglDjea1+awA=;
        fh=fVNdvY59faTXEKNxwDmFYtTd4LFrb2Kc6t8t8wSrPPQ=;
        b=AN+AF6va8d9RwMxgdT2V8GZ2+dbjdcXLKREM6I2CqWz3aIzZC1MOLmaSFfsR8J/O5R
         nrgDS0EPDwsbuZVMP85qCkSJPH0ny8RF47P8jBPJHJMU1TNPvNJWPNibLF1wjQ17hHHs
         OETHGXEA8kzn/t17zNiBTunfimLp0A4zHaLypI1LC8H24ukRUxJ5/nPTNI33YUhZtBO2
         LjFuc/fbUEWkmjf6M7xuIBi4EwrUpfR3/3l5o2Qmp3gOMfrAhnPbyWDyP3NKXnEng9aJ
         qQmiz/eK/OJR7XJXH4G21QLypZvB+amp6a27+TNQDuULISxGICUZJJpxHoBHzhb0wyot
         onIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772495103; x=1773099903; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u082M2vpZx7MrZkmV/F7ZdAH+CJQSjxHglDjea1+awA=;
        b=dKur1WsNzpmOhCi00v+OxvDQ3ckNtwPkm5cBnDpOWROLuSCozs4VQdwVOxCHSa3jpO
         zxwxS36YezuO5vI2ZtSDWJkY7CrydS/4Hc0JvsVDeccui5y848R/7uWKvAxUvaVM5ZVw
         s+yTaxidGeEdvVGwOwZE8VWfMQLuopWhD8HFrFxQd3hFmLAe0W7K1OZPYf617b1kYsH1
         gj6gJtN+CQxQqDTBz3UpAiD6RLHOfbjE2B42twCQ0MEg6qzInz9DbU/OyTFyb/bJa0J4
         ILg3Q59fFMs7rVJTzebeiryvrD93SaV3sFaHZPMrKSVTxbAgChysTewCUpTfqJA8gP4+
         y6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772495103; x=1773099903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u082M2vpZx7MrZkmV/F7ZdAH+CJQSjxHglDjea1+awA=;
        b=eu7OER5r6IcgnNNwP7efYNttkx41wZ4VUb24JS5llVkDPAkEaxgGqfAfA7Z3VXH9NZ
         6dYUmsO2G3zKYobROlswBoR64XXzm/1IJwPMVqkGtQx7O2GsuP1EmNInSQcyO68debXM
         Y/EJpjOGq38LrLX1rJTIt0dbZrzRCcNSA4OAL6fy/MzgL/lZALdu1rSe7QazzdVW+IWt
         a9y4bSEcQ6CXSqNpeJ/HfZBLnG2mO6Lj9U12pnQ6QSQpyy12OIHRi2URUwMUaNIC5S76
         8xFQGTPNaR0wMcZEBorTXJbfLeAiEE+AL6ksNpR2AR/9/shlDAe5bnc5YdiJyDVJ7llD
         kbrw==
X-Forwarded-Encrypted: i=1; AJvYcCUcAMSJvlE5E0tlqau4OFJrK0SoaWkIIKPHGs+nlOYZaKeoqN0jAmVsr3TFD6IwTAsCRxnTrKI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxpTJPotUl8lBOBzbZG0NV2+ZSDFDq9M71sF9w27hS3fdAOShgX
	VS7Wf9a1j7EPRI1QSIjtn0lhJ09KpqYx3cgOcWPZTMeR1yGK5bsTT4bRmVgwVpNyCzSBF5x9wVm
	HrhSMmIWMLs7va/xuN8pMWePAW5P1bOonrpF7ji8I
X-Gm-Gg: ATEYQzx2+YkTmcG1gMRK8ZoPj3tpfTa62L5jWvtLhjpcpyWuR6KwBIuCbvcqW+j9TmY
	P0km6FbrFT0+rCn19kXFFZiBg2itWrAmRhJujxP1gecUo7H+bOvvH5cq+Se8kKgHLKIR9B0wPgE
	YCKzYyLeHHJQDAdPeHpSey4sgnRio4WObE/s+JoVRxGe3C1eq8TwoY1Mo3kVR4BnPNN+jvqIIuk
	S+SjZZV7dY+aXf3NtQWWlzzAuum3vNw1eaVZbbf3dmRH9q0wOUD7KqrELlj7WoRyo3mO3bS3Scb
	e4RHk6c=
X-Received: by 2002:a17:90b:578e:b0:356:2eff:df05 with SMTP id
 98e67ed59e1d1-35965c9d15dmr12730172a91.16.1772495102745; Mon, 02 Mar 2026
 15:45:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org> <20260302-iino-u64-v2-3-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-3-e5388800dae0@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 2 Mar 2026 18:44:51 -0500
X-Gm-Features: AaiRm51Sffi2V1GbWbKQK3xjBHaGrjaqO3h4_HvI_INFaL56ZEFyr07E1_3tePs
Message-ID: <CAHC9VhRnmBuXEKkUPQhJ_LDzcksjoAJL-ne6mFoJdR1hnDdzsg@mail.gmail.com>
Subject: Re: [PATCH v2 003/110] audit: widen ino fields to u64
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Alexander Aring <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
	Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	John Johansen <john.johansen@canonical.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>, 
	Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Oliver Hartkopp <socketcan@hartkopp.net>, 
	Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Remi Denis-Courmont <courmisch@gmail.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Magnus Karlsson <magnus.karlsson@intel.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
	ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, 
	selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org, audit@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, 
	linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 2, 2026 at 3:25=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> inode->i_ino is being widened from unsigned long to u64. The audit
> subsystem uses unsigned long ino in struct fields, function parameters,
> and local variables that store inode numbers from arbitrary filesystems.
> On 32-bit platforms this truncates inode numbers that exceed 32 bits,
> which will cause incorrect audit log entries and broken watch/mark
> comparisons.
>
> Widen all audit ino fields, parameters, and locals to u64, and update
> the inode format string from %lu to %llu to match.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/audit.h   | 2 +-
>  kernel/audit.h          | 9 ++++-----
>  kernel/audit_fsnotify.c | 4 ++--
>  kernel/audit_watch.c    | 8 ++++----
>  kernel/auditsc.c        | 2 +-
>  5 files changed, 12 insertions(+), 13 deletions(-)

We should also update audit_hash_ino() in kernel/audit.h.  It is a
*very* basic hash function, so I think leaving the function as-is and
just changing the inode parameter from u32 to u64 should be fine.

--=20
paul-moore.com
