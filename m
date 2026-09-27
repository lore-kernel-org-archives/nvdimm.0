Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1073290B7;
	Sun, 27 Sep 2026 20:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790539528; cv=none; b=GuTL2w6vXeBCo2vNnZaf1GhMT7RWpgELRwbzZwDGvr8KpnufGMThdxFLBw8BHyReS84DaF6h0x5gX4tTEvQkI/0EHR3y2sJjG0RCBVuwKXT4xH6OOk6kLVunoDAOGVo0hINoyXflr5l2ioU4P2AXhmRKPgouF2I8JdOqWfnABSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790539528; c=relaxed/simple;
	bh=bWcQfAJiem49uAePLy5Kg6GLw+D2r/vW13dPJbDcnRw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=mjfG+ELgoMHrGCX8J6HCXSuDlJ2x7hFFTrLuD2pOOKfVTgYHUEca3U2VBhpCHExSHknnJLAsMVMh5vdd/82KQTYLlXESG0qSuB8ztleGz00ozB9P16hx7w436t4fX7W2Tc9ptDE4ykCgQBHKBus2j+Fy2FHEOnQLtyLxr/jT+6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=elv/EcRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="elv/EcRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783FD1F000FF;
	Sun, 27 Sep 2026 20:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790539526;
	bh=ibd7BdWjYrcLjTn/LBxjgIS3BMGCRPgcyae3ukA+Ld8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=elv/EcRa0A+aOJaup0Drx3OcMAhp/c6ojQd7HMn8SiAEwBg/M37TzqqplhYoMsMgh
	 a5W6Mbg645VbN0Y8YQca2tfvQOGMEtl4NGpPD6Zqe9co7MWkPbARkqSd9luqEBfRuv
	 tzg31HekoBu+fQYu+RRyMmUBPiBA6L/4Sp1osGa4=
Date: Sun, 27 Sep 2026 13:05:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiale Yao <yaojiale02@163.com>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Alison Schofield
 <alison.schofield@intel.com>, Joao Martins <joao.m.martins@oracle.com>,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] dax/device: defer publishing the dynamic pgmap
Message-Id: <20260927130526.a6da56f1515cf1772cb45631@linux-foundation.org>
In-Reply-To: <20260927114736.1113965-1-yaojiale02@163.com>
References: <20260927114736.1113965-1-yaojiale02@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 27 Sep 2026 19:47:36 +0800 Jiale Yao <yaojiale02@163.com> wrote:

> The dynamic device-dax probe path publishes its devm-allocated pgmap
> before several operations that can still fail.  If one of them fails,
> devres frees the pgmap while dev_dax->pgmap remains non-NULL.  A later
> bind then fails the dynamic-dax invariant check and leaves the device
> unusable until its region is recreated.
> 
> Defer assigning dev_dax->pgmap until the final devm action has been
> installed and probe can no longer fail.  A failed probe then never
> publishes the temporary pgmap.

lgtm, thanks.

> Fixes: fc65c4eb0b2a ("device-dax: ensure dev_dax->pgmap is valid for dynamic devices")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

I'll queue this for next-merge-window as it doesn't seem very urgent. 
Retaining cc:stable.  I've marked it as "needs maintainer acks".

