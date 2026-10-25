Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792897153;
	b=fyaKkH9L4bz1b9eBPWFgIzL3d/qQmOfwlz0p4AwE7C0ZaG42bqALt7r49X3yWIc0y1AV
	 zeP8FFoJoFFowQuF4wTZpoXeLqjeXmH2T5J5Nz8M30PJztj1dgwM1Urs0a9+onoyDXcUa
	 XFpS22onWly+2yFNNt+HSM4UrQpUm3Y7h5if+3hqKW+acSFUIVCTdjhvo08udOX8NRCJ9
	 TGdDbpJ78r8sI335hh4FyTtG7g+XPo2aFYDSEJEXUJdetIlI11RFRSrXTc6nRGZEdRyzx
	 aLac41w68AlrBm5wMGrv9A13y65NgSXs+Ek/BUrs2CZwTR5tDX2Gkp+MoqBVZwmQC8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792897153;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=1tSveiC9WG8nJMC82YjXaEy7jhVjm3LRsoK8sttDlLg=;
	b=md5d3FsyvIwvV+5LqPIVYhepw4LMYzpiPzYQ4Z1frHe+pa/2RhKeIwttjY4rQUWCorFP
	 St1yKgjrxKkzRcv4IIt7Ld7cJK/DQnK19lMyKFnKSSgg3+n8k8aOXkWKJ7xec4iTvjHLm
	 IVXTxHZsW1a0+EdouTr0+zXqQDoJGl1GZuXBn/3ngptgaEN0pBHzlKUvfnXTYOl44xr2U
	 LXi7agICoedO99ThtMZCF6114I0aY6sLXcnj5dPp41ADt5XLCd8eXO8T4C8O1DprOIuUO
	 sBK/UMPNH+5ndOWatR+45/c9rQn2viwEVNtCQDpp1h5D+Pu5GIBmMj+5osjtVFz/Dtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2SukEhAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFD7606A31A;
	Sun, 25 Oct 2026 02:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2SukEhAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937C71F01825;
	Sun, 25 Oct 2026 02:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792897151;
	bh=1tSveiC9WG8nJMC82YjXaEy7jhVjm3LRsoK8sttDlLg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2SukEhAWahl1LanuRCfpmWN9EAsZSd2DghzLxWqgSM/BdZOyTgSiWteYNq7sELApu
	 rS/6a9ICHLaAul7K/u+sy3oJb7tu0MnPlQmyqrU/D071n7iEK/EUJgg6Dt9OCmeMxt
	 5SmCwZ0znZy2DZPgUTGd6QOujsyeSEbOt+F3KCIk=
Date: Sat, 24 Oct 2026 19:59:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Joao Martins
 <joao.m.martins@oracle.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v5] dax/bus: Fix Device DAX range alignment validation
Message-Id: <20261024195911.64e9d7fbb7522bab8193911d@linux-foundation.org>
In-Reply-To: <5AFA3B1F-48C6-49FF-A6FF-7D71153671CF@linux.dev>
References: <20261024112555.2476001-1-songmuchun@bytedance.com>
	<20261024183853.6803ce81788636e94d8c16a4@linux-foundation.org>
	<5AFA3B1F-48C6-49FF-A6FF-7D71153671CF@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 25 Oct 2026 10:52:29 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> > your series "mm: Unify device DAX and HugeTLB vmemmap population paths"
> > exposes it.  That's 
> > 
> > 4b77739fe789 ("mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX").
> > 
> > I intend to send this to Linus next week.
> > 
> > Maybe also a Fixes: 4b77739fe789.  That series didn't create the bug,
> > but this data provides notification to people who are backporting this
> > series (unlikely) "hey, you need to add this fix as well".
> 
> Based on the above info, do you think it is necessary to include this
> commit as a Fixes tag? My inclination is to exclude it, because the
> issue is still there. It's just that it gets triggered earlier when the
> debug kernel is enabled.

OK, skip that.  This patch "dax/bus: Fix Device DAX range alignment
validation v5" has cc:stable anyway so things will work out.


