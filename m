Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E9242EEC4
	for <nvdimm@lists.linux.dev>; Thu, 26 Feb 2026 17:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772125249; cv=none; b=qVQXgsaqUmCz4+TVv/bplx2D3YkGTsh0MQQ+r/G/+9JDvOlA5FH2e9XBAWOy0jibR5ZBomLsY0t+SiUmexT1e6cBm1zb5SA908hgL+PlStiuyWV1yMPCNpmhSwXRLYkkHWA6uKvgTD3MD6DCvyyx9Owj/D7gz4y4ESpfT44x3Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772125249; c=relaxed/simple;
	bh=O6HHUUDrLr/eInYgsM941bFrgO4t8gNBauSRVXLgB2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BuQ1HvBL2WUlZ+JNwDQxhihBq9pPUr7uLo34UITCtkY/HeC4QGZpxd3ZdyULUOgtdm3iSGn2ZvCm073czKK8bUv+Kxj60bNKxsgKjSm7qdy621L5Czpiw89Ojk6MBTmkvh8EeEh3rnU0/W2Q4OozFRoePoeEUCp5RPmxMhZO1Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XJGRYCvU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HFKLpE5P; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=P0cj5v4E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qDd8WHtq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XJGRYCvU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HFKLpE5P";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="P0cj5v4E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qDd8WHtq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD9CC1FB1A;
	Thu, 26 Feb 2026 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772125243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UqxE3+lcinVC8tUtPMhxZS4tV0HDyUFUfF7VsRmpXg=;
	b=XJGRYCvUQEtIavuwyI0SAwKPiy3GZ/OGVFA/HK00Zt+6pITIKUpnRL9qJli9zFinAkD1W7
	Vxgy8eY26i46GzNiwxgtrpkXkYptZJCqiB05xpDR2FfG7+w4FXN6zZ2zwKUXqTSCs2t/PT
	iRkQO9+ZXTTMOyySveoDk4AAkQYE2SE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772125243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UqxE3+lcinVC8tUtPMhxZS4tV0HDyUFUfF7VsRmpXg=;
	b=HFKLpE5PEy48uwFKGnDhcBt+zN1U7QXn1+eST5YuNecl5/9geGKgIwMhoURm5MEd+cRRnD
	Ek1LpwK7K+IiblBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772125240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UqxE3+lcinVC8tUtPMhxZS4tV0HDyUFUfF7VsRmpXg=;
	b=P0cj5v4E6hRE7j8RzUgxGJPn1i5piS2UxiIx1ItwZ56RFolWcP2L5iYRpfabk3xpxJajdy
	2cskCjRdF1qAxrAvUUWm9uDlwOb5uzOicFHIkGNUOGU2xvBSrsDYnKZwwsWhpkbVWNZGW4
	nC9jI1iVB3z8PRq+9A6F/BRSx4k26yM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772125240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UqxE3+lcinVC8tUtPMhxZS4tV0HDyUFUfF7VsRmpXg=;
	b=qDd8WHtqgMZ3g7j76If0cqNMPcnUnXUjZYYYy50JHWmm2+96xHsEXdjzAcqO2Nfud1EwU2
	UYQIvBB456QifSAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A90923EA62;
	Thu, 26 Feb 2026 17:00:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Cg06KTh8oGmpPAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Feb 2026 17:00:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 545EAA0A27; Thu, 26 Feb 2026 18:00:36 +0100 (CET)
Date: Thu, 26 Feb 2026 18:00:36 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jan Kara <jack@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
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
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, 
	Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Anders Larsen <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, 
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
	ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org
Subject: Re: [PATCH 01/61] vfs: widen inode hash/lookup functions to u64
Message-ID: <cmxf6pu3xuwvbhg3alu725hd4b3dheowoumd6drolde7pypwor@eplss6764uuf>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-1-ccceff366db9@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226-iino-u64-v1-1-ccceff366db9@kernel.org>
X-Spamd-Result: default: False [-0.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	FORGED_RECIPIENTS(2.00)[m:viro@zeniv.linux.org.uk,m:jack@suse.cz,m:rostedt@goodmis.org,m:mathieu.desnoyers@efficios.com,m:dan.j.williams@intel.com,m:willy@infradead.org,m:osalvador@suse.de,m:dhowells@redhat.com,m:adilger.kernel@dilger.ca,m:jack@suse.com,m:neil@brown.name,m:okorniev@redhat.com,m:tom@talpey.com,m:sfrench@samba.org,m:ronniesahlberg@gmail.com,m:alex.aring@gmail.com,m:konishi.ryusuke@gmail.com,m:slava@dubeyko.com,m:lucho@ionkov.net,m:asmadeus@codewreck.org,m:linux_oss@crudebyte.com,m:dsterba@suse.com,m:marc.dionne@auristor.com,m:raven@themaw.net,m:salah.triki@gmail.com,m:aivazian.tigran@gmail.com,m:idryomov@gmail.com,m:amarkuze@redhat.com,m:jaharkes@cs.cmu.edu,m:coda@cs.cmu.edu,m:nico@fluxnic.net,m:code@tyhicks.com,m:amir73il@gmail.com,m:hch@infradead.org,m:glaubitz@physik.fu-berlin.de,m:frank.li@vivo.com,m:mikulas@artax.karlin.mff.cuni.cz,m:dwmw2@infradead.org,m:almaz.alexandrovich@paragon-software.com,m:mark@fasheh.com,m:jlbec@evilplan.org,m:miklos@szeredi.hu,m:al@alar
 sen.net,m:chengzhihao1@huawei.com,m:naohiro.aota@wdc.com,m:john.johansen@canonical.com,m:paul@paul-moore.com,m:serge@hallyn.com,m:roberto.sassu@huawei.com,m:dmitry.kasatkin@gmail.com,m:stephen.smalley.work@gmail.com,m:omosnace@redhat.com,m:casey@schaufler-ca.com,m:alexander.deucher@amd.com,m:christian.koenig@amd.com,m:airlied@gmail.com,m:simona@ffwll.ch,m:edumazet@google.com,m:kuniyu@google.com,m:pabeni@redhat.com,m:willemb@google.com,m:davem@davemloft.net,m:oleg@redhat.com,m:peterz@infradead.org,m:mingo@redhat.com,s:linux-mm@kvack.org,s:james.clark@linaro.org,s:alexander.shishkin@linux.intel.com,s:amd-gfx@lists.freedesktop.org,s:dri-devel@lists.freedesktop.org,s:linux-afs@lists.infradead.org,s:linux-mtd@lists.infradead.org,s:linaro-mm-sig@lists.linaro.org,s:fsverity@lists.linux.dev,s:netfs@lists.linux.dev,s:ntfs3@lists.linux.dev,s:nvdimm@lists.linux.dev,s:ocfs2-devel@lists.linux.dev,s:v9fs@lists.linux.dev,s:devel@lists.orangefs.org,s:samba-technical@lists.samba.org,s:jfs-discussion
 @lists.sourceforge.net,s:linux-f2fs-devel@lists.sourceforge.net,s:apparmor@lists.ubuntu.com];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_CC(0.00)[zeniv.linux.org.uk,kernel.org,suse.cz,goodmis.org,efficios.com,intel.com,infradead.org,mit.edu,linux.dev,suse.de,redhat.com,manguebit.org,dilger.ca,suse.com,oracle.com,brown.name,talpey.com,samba.org,gmail.com,microsoft.com,dubeyko.com,ionkov.net,codewreck.org,crudebyte.com,auristor.com,themaw.net,cs.cmu.edu,fluxnic.net,tyhicks.com,physik.fu-berlin.de,vivo.com,artax.karlin.mff.cuni.cz,nod.at,paragon-software.com,fasheh.com,evilplan.org,linux.alibaba.com,omnibond.com,szeredi.hu,alarsen.net,huawei.com,wdc.com,canonical.com,paul-moore.com,namei.org,hallyn.com,linux.ibm.com,schaufler-ca.com,amd.com,ffwll.ch,linaro.org,google.com,davemloft.net,arm.com,linux.intel.com,dev.tdt.de,vger.kernel.org,lists.linux.dev,kvack.org,lists.sourceforge.net,lists.samba.org,lists.infradead.org,coda.cs.cmu.edu,lists.orangefs.org,lists.ubuntu.com,lists.freedesktop.org,lists.linaro.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLs9g4ywj3srcibiwb6pkkw9we)];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[146];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -0.30
X-Spam-Level: 

On Thu 26-02-26 10:55:03, Jeff Layton wrote:
> Change the inode hash/lookup VFS API functions to accept u64 parameters
> instead of unsigned long for inode numbers and hash values. This is
> preparation for widening i_ino itself to u64, which will allow
> filesystems to store full 64-bit inode numbers on 32-bit architectures.
> 
> Since unsigned long implicitly widens to u64 on all architectures, this
> change is backward-compatible with all existing callers.
> 
> Functions updated:
>   - hash(), find_inode_fast(), find_inode_by_ino_rcu(), test_inode_iunique()
>   - __insert_inode_hash(), iget_locked(), iget5_locked(), iget5_locked_rcu()
>   - ilookup(), ilookup5(), ilookup5_nowait()
>   - find_inode_nowait(), find_inode_rcu()
>   - inode_insert5(), insert_inode_locked4()
>   - insert_inode_locked() (local variable)
>   - dump_mapping() (local variable and format string)
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c         | 46 +++++++++++++++++++++++-----------------------
>  include/linux/fs.h | 26 +++++++++++++-------------
>  2 files changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index cc12b68e021b2c97cc88a46ddc736334ecb8edfa..2cabec9043e8176d20aecc5ce7e0f276c114f122 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -672,7 +672,7 @@ static inline void inode_sb_list_del(struct inode *inode)
>  	}
>  }
>  
> -static unsigned long hash(struct super_block *sb, unsigned long hashval)
> +static unsigned long hash(struct super_block *sb, u64 hashval)
>  {
>  	unsigned long tmp;
>  
> @@ -685,12 +685,12 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
>  /**
>   *	__insert_inode_hash - hash an inode
>   *	@inode: unhashed inode
> - *	@hashval: unsigned long value used to locate this object in the
> + *	@hashval: u64 value used to locate this object in the
>   *		inode_hashtable.
>   *
>   *	Add an inode to the inode hash for this superblock.
>   */
> -void __insert_inode_hash(struct inode *inode, unsigned long hashval)
> +void __insert_inode_hash(struct inode *inode, u64 hashval)
>  {
>  	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
>  
> @@ -726,7 +726,7 @@ void dump_mapping(const struct address_space *mapping)
>  	struct dentry *dentry_ptr;
>  	struct dentry dentry;
>  	char fname[64] = {};
> -	unsigned long ino;
> +	u64 ino;
>  
>  	/*
>  	 * If mapping is an invalid pointer, we don't want to crash
> @@ -750,14 +750,14 @@ void dump_mapping(const struct address_space *mapping)
>  	}
>  
>  	if (!dentry_first) {
> -		pr_warn("aops:%ps ino:%lx\n", a_ops, ino);
> +		pr_warn("aops:%ps ino:%llx\n", a_ops, ino);
>  		return;
>  	}
>  
>  	dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
>  	if (get_kernel_nofault(dentry, dentry_ptr) ||
>  	    !dentry.d_parent || !dentry.d_name.name) {
> -		pr_warn("aops:%ps ino:%lx invalid dentry:%px\n",
> +		pr_warn("aops:%ps ino:%llx invalid dentry:%px\n",
>  				a_ops, ino, dentry_ptr);
>  		return;
>  	}
> @@ -768,7 +768,7 @@ void dump_mapping(const struct address_space *mapping)
>  	 * Even if strncpy_from_kernel_nofault() succeeded,
>  	 * the fname could be unreliable
>  	 */
> -	pr_warn("aops:%ps ino:%lx dentry name(?):\"%s\"\n",
> +	pr_warn("aops:%ps ino:%llx dentry name(?):\"%s\"\n",
>  		a_ops, ino, fname);
>  }
>  
> @@ -1087,7 +1087,7 @@ static struct inode *find_inode(struct super_block *sb,
>   * iget_locked for details.
>   */
>  static struct inode *find_inode_fast(struct super_block *sb,
> -				struct hlist_head *head, unsigned long ino,
> +				struct hlist_head *head, u64 ino,
>  				bool hash_locked, bool *isnew)
>  {
>  	struct inode *inode = NULL;
> @@ -1301,7 +1301,7 @@ EXPORT_SYMBOL(unlock_two_nondirectories);
>   * Note that both @test and @set are called with the inode_hash_lock held, so
>   * they can't sleep.
>   */
> -struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
> +struct inode *inode_insert5(struct inode *inode, u64 hashval,
>  			    int (*test)(struct inode *, void *),
>  			    int (*set)(struct inode *, void *), void *data)
>  {
> @@ -1378,7 +1378,7 @@ EXPORT_SYMBOL(inode_insert5);
>   * Note that both @test and @set are called with the inode_hash_lock held, so
>   * they can't sleep.
>   */
> -struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
> +struct inode *iget5_locked(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *),
>  		int (*set)(struct inode *, void *), void *data)
>  {
> @@ -1408,7 +1408,7 @@ EXPORT_SYMBOL(iget5_locked);
>   * This is equivalent to iget5_locked, except the @test callback must
>   * tolerate the inode not being stable, including being mid-teardown.
>   */
> -struct inode *iget5_locked_rcu(struct super_block *sb, unsigned long hashval,
> +struct inode *iget5_locked_rcu(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *),
>  		int (*set)(struct inode *, void *), void *data)
>  {
> @@ -1455,7 +1455,7 @@ EXPORT_SYMBOL_GPL(iget5_locked_rcu);
>   * hashed, and with the I_NEW flag set.  The file system gets to fill it in
>   * before unlocking it via unlock_new_inode().
>   */
> -struct inode *iget_locked(struct super_block *sb, unsigned long ino)
> +struct inode *iget_locked(struct super_block *sb, u64 ino)
>  {
>  	struct hlist_head *head = inode_hashtable + hash(sb, ino);
>  	struct inode *inode;
> @@ -1527,7 +1527,7 @@ EXPORT_SYMBOL(iget_locked);
>   *
>   * Returns 1 if the inode number is unique, 0 if it is not.
>   */
> -static int test_inode_iunique(struct super_block *sb, unsigned long ino)
> +static int test_inode_iunique(struct super_block *sb, u64 ino)
>  {
>  	struct hlist_head *b = inode_hashtable + hash(sb, ino);
>  	struct inode *inode;
> @@ -1616,7 +1616,7 @@ EXPORT_SYMBOL(igrab);
>   *
>   * Note2: @test is called with the inode_hash_lock held, so can't sleep.
>   */
> -struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
> +struct inode *ilookup5_nowait(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *), void *data, bool *isnew)
>  {
>  	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
> @@ -1647,7 +1647,7 @@ EXPORT_SYMBOL(ilookup5_nowait);
>   *
>   * Note: @test is called with the inode_hash_lock held, so can't sleep.
>   */
> -struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
> +struct inode *ilookup5(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *), void *data)
>  {
>  	struct inode *inode;
> @@ -1677,7 +1677,7 @@ EXPORT_SYMBOL(ilookup5);
>   * Search for the inode @ino in the inode cache, and if the inode is in the
>   * cache, the inode is returned with an incremented reference count.
>   */
> -struct inode *ilookup(struct super_block *sb, unsigned long ino)
> +struct inode *ilookup(struct super_block *sb, u64 ino)
>  {
>  	struct hlist_head *head = inode_hashtable + hash(sb, ino);
>  	struct inode *inode;
> @@ -1726,8 +1726,8 @@ EXPORT_SYMBOL(ilookup);
>   * very carefully implemented.
>   */
>  struct inode *find_inode_nowait(struct super_block *sb,
> -				unsigned long hashval,
> -				int (*match)(struct inode *, unsigned long,
> +				u64 hashval,
> +				int (*match)(struct inode *, u64,
>  					     void *),
>  				void *data)
>  {
> @@ -1773,7 +1773,7 @@ EXPORT_SYMBOL(find_inode_nowait);
>   *
>   * The caller must hold the RCU read lock.
>   */
> -struct inode *find_inode_rcu(struct super_block *sb, unsigned long hashval,
> +struct inode *find_inode_rcu(struct super_block *sb, u64 hashval,
>  			     int (*test)(struct inode *, void *), void *data)
>  {
>  	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
> @@ -1812,7 +1812,7 @@ EXPORT_SYMBOL(find_inode_rcu);
>   * The caller must hold the RCU read lock.
>   */
>  struct inode *find_inode_by_ino_rcu(struct super_block *sb,
> -				    unsigned long ino)
> +				    u64 ino)
>  {
>  	struct hlist_head *head = inode_hashtable + hash(sb, ino);
>  	struct inode *inode;
> @@ -1833,7 +1833,7 @@ EXPORT_SYMBOL(find_inode_by_ino_rcu);
>  int insert_inode_locked(struct inode *inode)
>  {
>  	struct super_block *sb = inode->i_sb;
> -	ino_t ino = inode->i_ino;
> +	u64 ino = inode->i_ino;
>  	struct hlist_head *head = inode_hashtable + hash(sb, ino);
>  	bool isnew;
>  
> @@ -1884,7 +1884,7 @@ int insert_inode_locked(struct inode *inode)
>  }
>  EXPORT_SYMBOL(insert_inode_locked);
>  
> -int insert_inode_locked4(struct inode *inode, unsigned long hashval,
> +int insert_inode_locked4(struct inode *inode, u64 hashval,
>  		int (*test)(struct inode *, void *), void *data)
>  {
>  	struct inode *old;
> @@ -2642,7 +2642,7 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
>  		break;
>  	default:
>  		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
> -				  " inode %s:%lu\n", mode, inode->i_sb->s_id,
> +				  " inode %s:%llu\n", mode, inode->i_sb->s_id,
>  				  inode->i_ino);
>  		break;
>  	}
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25ec12b00ac1df17a952d9116b88047..dfa1f475b1c480c503ab6f00e891aa9b051607fa 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2935,32 +2935,32 @@ static inline int inode_generic_drop(struct inode *inode)
>  extern void d_mark_dontcache(struct inode *inode);
>  
>  extern struct inode *ilookup5_nowait(struct super_block *sb,
> -		unsigned long hashval, int (*test)(struct inode *, void *),
> +		u64 hashval, int (*test)(struct inode *, void *),
>  		void *data, bool *isnew);
> -extern struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
> +extern struct inode *ilookup5(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *), void *data);
> -extern struct inode *ilookup(struct super_block *sb, unsigned long ino);
> +extern struct inode *ilookup(struct super_block *sb, u64 ino);
>  
> -extern struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
> +extern struct inode *inode_insert5(struct inode *inode, u64 hashval,
>  		int (*test)(struct inode *, void *),
>  		int (*set)(struct inode *, void *),
>  		void *data);
> -struct inode *iget5_locked(struct super_block *, unsigned long,
> +struct inode *iget5_locked(struct super_block *, u64,
>  			   int (*test)(struct inode *, void *),
>  			   int (*set)(struct inode *, void *), void *);
> -struct inode *iget5_locked_rcu(struct super_block *, unsigned long,
> +struct inode *iget5_locked_rcu(struct super_block *, u64,
>  			       int (*test)(struct inode *, void *),
>  			       int (*set)(struct inode *, void *), void *);
> -extern struct inode * iget_locked(struct super_block *, unsigned long);
> +extern struct inode *iget_locked(struct super_block *, u64);
>  extern struct inode *find_inode_nowait(struct super_block *,
> -				       unsigned long,
> +				       u64,
>  				       int (*match)(struct inode *,
> -						    unsigned long, void *),
> +						    u64, void *),
>  				       void *data);
> -extern struct inode *find_inode_rcu(struct super_block *, unsigned long,
> +extern struct inode *find_inode_rcu(struct super_block *, u64,
>  				    int (*)(struct inode *, void *), void *);
> -extern struct inode *find_inode_by_ino_rcu(struct super_block *, unsigned long);
> -extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
> +extern struct inode *find_inode_by_ino_rcu(struct super_block *, u64);
> +extern int insert_inode_locked4(struct inode *, u64, int (*test)(struct inode *, void *), void *);
>  extern int insert_inode_locked(struct inode *);
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  extern void lockdep_annotate_inode_mutex_key(struct inode *inode);
> @@ -3015,7 +3015,7 @@ int setattr_should_drop_sgid(struct mnt_idmap *idmap,
>   */
>  #define alloc_inode_sb(_sb, _cache, _gfp) kmem_cache_alloc_lru(_cache, &_sb->s_inode_lru, _gfp)
>  
> -extern void __insert_inode_hash(struct inode *, unsigned long hashval);
> +extern void __insert_inode_hash(struct inode *, u64 hashval);
>  static inline void insert_inode_hash(struct inode *inode)
>  {
>  	__insert_inode_hash(inode, inode->i_ino);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
