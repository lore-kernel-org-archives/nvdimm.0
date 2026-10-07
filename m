Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C503CF952;
	Wed,  7 Oct 2026 19:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791403174; cv=none; b=DgBfimKR7TcVtap/I5bD4Q5HIxGhm80JfJRdnwZaXHMKCSWUkd77ByvooUmzfX/7QZBYBXBLEW7KURSPPOwdZN2708HxQJbD1IeerrVecPdKqDyKu/MoYqgbd0mOs0myfP4j8nvDO9RGhs5cL8w7IzJkU8Ukt4otKPOjoVTIsRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791403174; c=relaxed/simple;
	bh=umFjFOpgWzcg8yfYffyeeeTNKpvrcD4z7idrM5x6cuU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=P4VLe1zYa7jZgcC6CGX4avPRioIWiZEn3EmDsf9NGGGU+qa6vevgHP6qxuAwasYotcC0jOiMHCfdj3LtRTtOAUlPhPfEVaO5F0h2WHNl0kJr1gE0B+qawfv1+wOtHM3OiNe1aX8gnazeG2RHJfOj1iEoljUx809jjMlO8R0QYjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5221A72F1;
	Wed,  7 Oct 2026 19:50:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf16.hostedemail.com (Postfix) with ESMTPA id AC2E420018;
	Wed,  7 Oct 2026 19:49:59 +0000 (UTC)
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 33731F40066;
	Wed,  7 Oct 2026 15:49:59 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Wed, 07 Oct 2026 15:49:59 -0400
X-ME-Sender: <xms:Z6LGasKFXyToOsO4bjD9S6jkP0kqYK3NoN8nclp2548e3l8fs7faIg>
    <xme:Z6LGam8TP7UVNmqUzZc7UwK0toDtnpxx1b1VOHxG7SB6Iq_IKlfmuNpWh4LBol8j-
    toVkNUAtjpSYvdHT0oDh2fUXVDm3urbgsgndiGQ7ZeDg2rH5CLkwsQ>
X-ME-Proxy-Cause: dmFkZTF5whV9yx0Fc4W4jHKRgoi2fIeukpPmUZ6fG3nVx1vxaSr9EdrAFx4tpIp+7xxsGO
    JhTiGGfrw/MRK7JtNumUbXLbrOkNuycKDJVqAGp5/ZhKq4q6L9FUPkLdsBP7UQKcAv+Q4z
    +pyxPiRC4JJInLtOpGt719l4wFStqXSGcY4Rkjjes0mj0vHq1Udy1IppNURdhnFIrANxB0
    WbNvkQDD986qGxHm5Y8Dri1SptpCSfUyuMzFyE7YuYf7aln8YEqz/+Meh/UZyfoqb/nJxH
    aC2uslS/lqpqWeSMur0WDlj4kueg55yvZpZKLOwOaTyB+svmNwO3g0D9JbWDoRHlt0TqVf
    pA7ndR8Lq3brifJKetNyZgqdylp6DcpTWXtswSkxDHtANAXI7sQWKj5+YBfI8Y8STAN7vc
    RgaQkAzFdRWrDIL4Lze4kgr7PGnHLf1zlwXvBebAqJSfk0LUV+CcLDdhgMC0+WdFhsxz6z
    UbF5tIIKXNqjg/5k3aoeM+AvlZq0b3APAcAPWYnONlxYFxUxcelBTgtnV78etGvM9ADM5h
    wHt9bcx7W44O0MUryJU7MKNHUklJ30BcIPuNY4QcZgGzERxEL5Z3fcr3ilhrlTsBjPJ9pL
    kTXDffNLG1QZJKgKDptNk8k98EAyEVhBqXrBKNulaQktxVgSLEReihtw+GjQ
X-ME-Proxy: <xmx:Z6LGattKnLd2dn3Cxmlv_fXhoGjfnuO460ksIOcZGmZf7-1_1ETouw>
    <xmx:Z6LGaiV0lXub33a4YnCaKt1w_5cdbFkOR5KAKjDxUT12AtImn3JOPg>
    <xmx:Z6LGatzM4tyEgRL4xtSJJE-8fn-e8NnaVbBVTvq9fmcMqCRH4pFp3w>
    <xmx:Z6LGapFMoDB0vIQZNBA9Wag9nQjk6z5xZHmxG-vwLP3A5zFwcraZ0g>
    <xmx:Z6LGaisZCNWcxGtaCIxJHJbKhlOwfFnPaJ76JCFm9eYuBTOPbJMY47pO>
Feedback-ID: i3a164872:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 155F1700065; Wed,  7 Oct 2026 15:49:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 07 Oct 2026 14:49:38 -0500
From: "John Groves" <john@groves.net>
To: "Miklos Szeredi" <miklos@szeredi.hu>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Alison Schofield" <alison.schofield@intel.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Cc: "fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>,
 "Carlos Maiolino" <cem@kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <d23cb148-85b4-471d-9e6a-d9236ca7c03b@app.fastmail.com>
In-Reply-To: 
 <CAJfpeguyOXGQO4Q8rSAc8GxExTJU0G2o19fxRnh_93GvAoNcRg@mail.gmail.com>
References: 
 <CAJfpeguyOXGQO4Q8rSAc8GxExTJU0G2o19fxRnh_93GvAoNcRg@mail.gmail.com>
Subject: Re: fs_put_dax() vs. dax_holder_notify_failure() race
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yzerca3i1py6mksruia6jktc9o7fgqm1
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: AC2E420018
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX194ACm1O50BK2wZR58jRvCq1GkjUS9hdpQ=
X-HE-Tag: 1791402599-523858
X-HE-Meta: U2FsdGVkX19/PjMHISUe5fosXxRaP4AkvwYpg+D0wk4ct3aHEulJ/W9TwIXI++8AtI9Aj0N+A7wftuZpdqx5rq0Gyuwl6hLmGBnG3SCzJIhfdM3JsEfU1D1ZT4acpUeW15fOTyJ8v3DQWLfNhXKkWuZudFGzGqVH8IdHeyONIf41dwOimliN+BbKuWjPjl+oy0HBWrj/ToFJjzahnacPV+dyFySBIjIP6T1Z/6AUIwRaqdCLr8BPaMw7vyJ5wCAlgl6vfPhM24FlSL07UX3PDM/6Vj5FLfsZK95Mf205C5bJ6JbDpKlhowichWaZ2kHG



On Wed, Sep 30, 2026, at 9:29 AM, Miklos Szeredi wrote:
> During ->notify_failure() callback will dereference holder.  It may be
> NULL at this point, resulting in an Oops, or it may be non-NULL but be
> freed during that call, resulting in UAF.
> 
> This affects xfs at this point, but the fuse extent map patchset[1]
> also adds dax failure handling and is affected by this issue.
> 
> I think this should be fixed in drivers/dax/super.c, since this will
> be a problem in each user.
> 
> Thanks,
> Miklos

I've seen a bunch of variants of this from Sashiko; will give it a proper
review and fix, but some things are higher on my triage pile (e.g. validating
that file ext_maps work as they should, and offering an improved 
fault/begin handler.

All of that and more is coming asap...

Thanks,
John
