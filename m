Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBA52D7DEF
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 13:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783862367; cv=none; b=AuRLDf+Uh7Le9ne4pc5veXtpDTPu7dseq28S9548zh5y3RIHPihvpj2UZ1HlXE3Nih3B4hsYu3hfAz1371oGzeJ/WAodqcoUJ+sphXQNkj7u12RvF2jOjExwOjRi1MLiBTTg0/+vN4NSsy+D/F04xpEu+U4I7xVCg/r0tp0Zq2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783862367; c=relaxed/simple;
	bh=GA2n3X3YYxv/xqLwggfAp+Psl9pqkPA1TJ/rGYjWIzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TOkTtC2nNXNJRFwlkEFk+meqshDbRKaaT30NLSq2/TG4gYAD4ATDv6l6+gKWQ56JWCs7EE9HI6Q/qzVE3cV3uruadmeGw90lHaDaLk2RSpa1XXRvEzjP7HsggyQy4z4QUecH4eiB6/OQ6LtEuIu+3qzZo4PXVXp22xJvEFAWD7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=g3yIfvuZ; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="g3yIfvuZ"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e6a434cabso126630985a.1
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 06:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783862364; x=1784467164; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=39bk0iOpnnnuS6FEq1W2d71iiM95MbzJdYJU5SoGT3c=;
        b=g3yIfvuZDYuglaUbAwqsLYRb4xDk2ogwAjMexQhb4fWTA1N+rI9bWqPslCt6qg28BD
         fHcFZyuVQG9CKc9hIc2Yxcvyq5WorugIilj6KBa2tqFJ6CxlKhhzlltSbstOYyw3XULi
         vwfoFFCLPUiCT+4HVlmfqGWfznXojsQuKF9gWZs8CShqZIcT2aCvJQJ37/7xwmz1Br84
         J43o1Ru13/pRAjt7vaUNUtFIiGGS0Xfvjx6r345yiJ6gD0brC2z4K37iOn2s3eCW6yTo
         2OKiGUalu1NFbcEhYw43Tv0P0xYnLgyc7wlArT4cZY6WfK6NdlUJNAvN2tkq0TTDhRf7
         qdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783862364; x=1784467164;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=39bk0iOpnnnuS6FEq1W2d71iiM95MbzJdYJU5SoGT3c=;
        b=KHEE7FC6epsnoZM+ARZCV8dFlhOy5G91y9xTCkvoOl8Nud/3eEll7cu8eMQs+TkPGg
         SE66JTUTquXfYPJ/wHnkRQ7IxSwq/0ShbiQeQKCyO2AYmXshiRJ/ioyhWySG4Jf1Fwtn
         k8B4MxtCmEYuTgtZIaySdzJnRmdArG8cB+DXbS5bMABArWWyWSkJh15f+pA/33SWIm9V
         S4GjkduF+qfBSFSfAp5w54zLL3EhuSxBpMA33FJetP72JVvAh85qp8fvRX2EqROlglab
         wKIozyU0TPwHgJFSyD4HnbgACU0xqTMPYt0D/W5A5APP0t+8bVNmhUEXcyj+oeWab+xY
         H6JA==
X-Forwarded-Encrypted: i=1; AHgh+RrS4IzHqtceIDwUHGQtosy9TyqWWeHYtV/HYMcpOeSZKudTFFaSHy/YmL+mDVrZH+pi4v0tES8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxT5uwh6GEKpiwysKXHBQhIEOXd0+Bgop/Ik8zMr5Wcx/Kh9Ha
	l4zuq9VblCGv2YTiYe4uaHibkQO9ql5X+uDT4s6fr2y8rzKquyJNPIvOYjNoit8Dy5E=
X-Gm-Gg: AfdE7ckfYG7y6jMCLNzm44+fdWaB9vkNEO3Hy0EG8Y5vcQAw5635NQzkoNcIgy1H8jD
	2Ds5PxpuulO8pQ8NLqO6Y0Et2sa/vNbNmGhl2L+7Aj2mYTwKODCKn8OCeDazz7SFbSLlWuNdGvO
	mGYCauRfTBSN2DIv5XJIA13JrRHBZwVW17o/PqpWCnD/wMTrjH5KQTiXXqZWSzznKL7n6qGMHof
	1JA9FsLbfcNh+7i2FcmSkROa6Lzm4HqHuGi6Cey96RGprpWf+QDIuOxpxRYAAsGSLgSaH8FLmZ1
	WzbCVxaKxNzoWmWN/vJ65waKNxwFUPNvaa5h1Ur+4F8DPTXAqLEOrrcKKygdGvQx/bHkJRmNqPB
	Z+8RWkdgtpV3BjKk6XEzvhvoz72bJa/fdUctY4+01taqiGHS5hs2SbegwZUUF0ksdqZDZ8wNCXk
	ltMA+uouVfu4fNI4gIm7k+M+qlnlSSN9xUuGeCFVWz2QD1qhaO13+K1cJRc5DRcKIdyPGq
X-Received: by 2002:a05:620a:28cb:b0:92e:94a7:16e8 with SMTP id af79cd13be357-92ef2b354f5mr605721685a.15.1783862364130;
        Sun, 12 Jul 2026 06:19:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5b4b38dsm900591885a.10.2026.07.12.06.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 06:19:23 -0700 (PDT)
Date: Sun, 12 Jul 2026 09:19:18 -0400
From: Gregory Price <gourry@gourry.net>
To: "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Message-ID: <alOUVvJCSQDO6yNn@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
 <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
 <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
 <alBLJoM86ujz5Fg1@gourry-fedora-PF4VCD3F>
 <6a51920acece6_35cf3310061@djbw-dev.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1q15GSERqnHPArbK"
Content-Disposition: inline
In-Reply-To: <6a51920acece6_35cf3310061@djbw-dev.notmuch>


--1q15GSERqnHPArbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 10, 2026 at 05:44:58PM -0700, Dan Williams (nvidia) wrote:
> Gregory Price wrote:
> > On Thu, Jul 09, 2026 at 06:08:45PM -0400, Gregory Price wrote:
> > > On Thu, Jul 09, 2026 at 02:46:39PM -0700, Dan Williams (nvidia) wrote:
> > > 
> > > This was more a matter of having the DEFAULT set consistently across
> > > the dax driver variant probe() functions to make the behavior explicit.
> > > I didn't want an un-set value bug to creep in here somehow.
> > > 
> > > Happy to drop them if you think that's unneeded.
> > > 
> > 
> > Ah
> > 
> > Not setting the value in each of those places is equivalent to setting
> > MMOP_OFFLINE (0), so better to just set DEFAULT regardless.
> > 
> > So unless you have strong feelings i will keep them as-is.
> 
> Right, the mild feelings are only coming from the changelog mismatch
> which says "Oh no, device-dax drivers can not specify their online type
> besides the default" and all this series does is keep the status quo.
> 
> That can be had by just having unconditional:
> 
>      online_type = mhp_get_default_online_type();
> 
> ...in dev_dax_kmem_probe() and get rid of dev_dax->online_type until the
> first user arrives. If you are respinning the series and that patch
> drops, yay. If not, oh well.

if you prefer, i can add the CXL build option to this series instead of
the follow up (attached).  The code is fully contained in DAX anyway,
and I have it sitting off in another branch anyway.

I suppose with this, we can terminate the entire series and the first
user that grows an opinion can add the following:

cxl/cxl.h:
    struct cxl_dax_region *cxlr_dax {
    +   int online_type
    };

dax/cxl.c:
   data.online_type = (cxlr_dax.online_type == DAX_ONLINE_DEFAULT) ?
                      cxl_dax_online_type() : cxlr_dax.online_type;

~Gregory

--1q15GSERqnHPArbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename=0001-dax-cxl-add-build-time-CXL-RAM-region-auto-online-po.patch

From b2cb5c4f5f03dd698df97ae3db2c0207db4acd83 Mon Sep 17 00:00:00 2001
From: Gregory Price <gourry@gourry.net>
Date: Thu, 9 Jul 2026 19:31:28 -0700
Subject: [PATCH] dax/cxl: add build-time CXL RAM region auto-online policy

CXL devices using kmem follow the single global auto-online policy.

On systems with multiple drivers using memory hotplug, this makes
management more complex - a single special kmem device forces all
kmem devices to be managed manually in userland.

Add a build-time option to select CXL device online policy.

  - System default   -> DAX_ONLINE_DEFAULT (default)
  - Online           -> MMOP_ONLINE
  - Online (movable) -> MMOP_ONLINE_MOVABLE
  - Online (kernel)  -> MMOP_ONLINE_KERNEL
  - Unplugged        -> DAX_KMEM_UNPLUGGED

Default to system default to retain userland backward compatibility.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/Kconfig | 41 +++++++++++++++++++++++++++++++++++++++++
 drivers/dax/cxl.c   | 15 ++++++++++++++-
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index 80aeb0d556bd7..52450225dbb11 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -212,6 +212,47 @@ config CXL_REGION
 
 	  If unsure say 'y'
 
+choice
+	prompt "CXL Memory Hotplug Policy"
+	depends on CXL_REGION
+	default CXL_MEMHP_POLICY_SYSTEM_DEFAULT
+	help
+	  Select the online policy the CXL driver requests when a region is
+	  hotplugged as System RAM.
+
+	  If unsure, select "System default".
+
+config CXL_MEMHP_POLICY_SYSTEM_DEFAULT
+	bool "System default"
+	help
+	  Follow the system-wide memory hotplug policy.
+
+config CXL_MEMHP_POLICY_ONLINE
+	bool "Online"
+	help
+	  Automatically online memory and let the kernel choose the zone.
+
+config CXL_MEMHP_POLICY_ONLINE_MOVABLE
+	bool "Online (movable)"
+	help
+	  Automatically online the memory into ZONE_MOVABLE. Choose this for
+	  memory that may need to be hotremoved later, or if you do not want
+	  unmovable, kernel allocations to land on this memory.
+
+config CXL_MEMHP_POLICY_ONLINE_KERNEL
+	bool "Online (kernel)"
+	help
+	  Automatically online the memory into ZONE_NORMAL. The kernel may
+	  place unmovable allocations on this memory.
+
+config CXL_MEMHP_POLICY_UNPLUGGED
+	bool "Unplugged"
+	help
+	  Create the dax/kmem device but add no memory at bind time.
+	  Choose this if a userland orchestrator will manage the device.
+
+endchoice
+
 config CXL_REGION_INVALIDATION_TEST
 	bool "CXL: Region Cache Management Bypass (TEST)"
 	depends on CXL_REGION
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 1a7ec62122134..15f70d578c22b 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -6,6 +6,19 @@
 #include "../cxl/cxl.h"
 #include "bus.h"
 
+static int cxl_dax_online_type(void)
+{
+	if (IS_ENABLED(CONFIG_CXL_MEMHP_POLICY_UNPLUGGED))
+		return DAX_KMEM_UNPLUGGED;
+	if (IS_ENABLED(CONFIG_CXL_MEMHP_POLICY_ONLINE))
+		return MMOP_ONLINE;
+	if (IS_ENABLED(CONFIG_CXL_MEMHP_POLICY_ONLINE_MOVABLE))
+		return MMOP_ONLINE_MOVABLE;
+	if (IS_ENABLED(CONFIG_CXL_MEMHP_POLICY_ONLINE_KERNEL))
+		return MMOP_ONLINE_KERNEL;
+	return DAX_ONLINE_DEFAULT;
+}
+
 static int cxl_dax_region_probe(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
@@ -27,7 +40,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
-		.online_type = DAX_ONLINE_DEFAULT,
+		.online_type = cxl_dax_online_type(),
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
-- 
2.53.0-Meta


--1q15GSERqnHPArbK--
