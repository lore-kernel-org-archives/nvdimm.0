Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB131E260C
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 22:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782857685; cv=none; b=G4OQ7QrgBBVzPQYS7uiu+5n3xCLU3aeV2Ae7XkqcT+ap8vm00KLTcwla9ln5NXgHGx30wUYAToF1D8RLWx9o9GHIYSyWlaHNX8BbtIQcd+eGmZavwU+eeFpUG/vmwpIng1GrKpZGHSpik5qaUkoDZhe70PXirASgkHVHxwKVbuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782857685; c=relaxed/simple;
	bh=OHho8xisLBkXPsux52lTSAnNEXH9FZ3N849yTj8opFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5yJu9yYbdUHhWrm2NgBDUdicZSuZQzsz9nQuFezdSTkOrD12dY9xYGtOvDy1dDspPgJZQ+UJzRD6o9M1oLz3NxzNU9rhPWcJKgpESfe/nDHjtbowH4HZtSnZQ5vQDpF50oYVKLWksW5itsGkOoxc4WLq9tlr+go4D+XqIJYcb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=LXd5yLrm; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="LXd5yLrm"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e67555e24so106917685a.3
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 15:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782857681; x=1783462481; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zvvq7XwN+0vU39EaqWqw5+H08MVeyEUcwD3F1pdYD7Y=;
        b=LXd5yLrmqWS/QgFsTPqZ6xaUiuThvJ4K+S5LICjIe/VGYZxh4kHo6vL+3Yrrwps08b
         d9cl5d6x2BjlScbRQgQMfFDAZLTPTF8M6u+17N3ovYuzhHDe+q03NZGaeRRPALMrhfNB
         xIsex+SOUAWYJ8Yje3yzM0VnBsFvQuSIuGLoIHfMy1YC+cVGEuRQR1AyNgSFuqNnzY5f
         GZm3EG5L53r/rTum5+fn9om7xjVbCWVmuQtkvgmelkENEuL/2+yxg5PK9mR7Rqgfl7Ny
         m1OtyG2QOiDeeJnfWqXCy5xM6dOOp0xvLO/7e0ew+L2G0d2orLcodNbnp6nsbZvISyyc
         rSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782857681; x=1783462481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zvvq7XwN+0vU39EaqWqw5+H08MVeyEUcwD3F1pdYD7Y=;
        b=busQu/QhTLf01WcLYqod6HoYho3qTALioUF62jYU7oTxoLdVWY08qlULJGeALk10RC
         PzZROPfpTPe3qkei+uwGaw8cjmAgC7uRzP1fuU1kHSZinILl9Ak5WUsSFwwTPB7o5rSj
         qWupXxGNnd1M3T2W1JcWKFp8f4hhR+gl17ZnVYxDrLCSUeAVCFCJVlHesOg2GRtQQk9x
         bgD286DQ+sMJbqZRBFGgaGK7Yjv+eS5Ue9azRXCNX1u2rt+uwOMt2DuTYZWjR3YFRg4S
         Q7iEsTgTYlpSOvWS2yVyCSM4FDhSv+6kFFZe9O22U+X/FKLdauljyu9biGdGNu+rMm/U
         AmzQ==
X-Gm-Message-State: AOJu0YwHFLoipTf6SRNAmloMsPwDZoiErn4nPd6XFjl9gCW+C9hXPxoN
	L/z/pcrykaJiBOtWo9W3U9g+zLI98+dtZmLou7ndM8ex0zXqdvQ4+7QkMFveucH+0kU=
X-Gm-Gg: AfdE7ckD50oGdW+RRP6LEE2bJBe10q/L9vXeHFTzENSmSIwW90Hac5WRuHkXBN5Wxxt
	ONalClIAR2hGXkUR+L1pMMwBrJURhg8Fv21M94rqAsK590UoWDzQXmlExeHb9GI8T5UXirBHAhP
	2YmD7+GMIA0ih9NrP2vxouRHAif4dO+R8olfyQUlSN8MfF1eqEPDPHuhQ23LiqLL8ZLFrJLvU32
	4QD+6z/vTcDSHx4KTCH6uiQQCYD7K2bli7i48jhlCElDkIbvYlYfdtXKTjXkLcbbB58reO+7wEM
	8txSAXs/Z25tuN2GacJ/lqvRVd1ndl0aVH+A/Nlm98Wo+3Xp/ZTddAZgrEWpxIQnNh5BWf7XI49
	5E/fLYn7vYgNBhepfXyBCad1YoyxE7Itj+YE7hXfirUswu0HHntcklfYQaiNnjDOlALjQsOpL4K
	1mavWJA9d9MIkttTSTcHneNC3LUmOt41Aq3dTVTt2qax99vR8L0k2O1XIL6+d3MMl9cdQ3ugC+i
	pk+Qzw=
X-Received: by 2002:a05:620a:6cc6:b0:915:b852:4361 with SMTP id af79cd13be357-92e624e3088mr975087285a.20.1782857681333;
        Tue, 30 Jun 2026 15:14:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6213b953sm346810685a.2.2026.06.30.15.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 15:14:40 -0700 (PDT)
Date: Tue, 30 Jun 2026 18:14:30 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com,
	david@kernel.org, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <akQ_xlJtXNgnGUdf@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Ha7M+e+kLoFbO4pS"
Content-Disposition: inline
In-Reply-To: <20260630211842.2252800-10-gourry@gourry.net>


--Ha7M+e+kLoFbO4pS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 30, 2026 at 05:18:41PM -0400, Gregory Price wrote:
> There is no atomic mechanism to offline and remove an entire
> multi-block DAX kmem device.  This is presently done in two steps:

... snip snip snip ...

Sashiko pointed out a false-positive, but adding a fixup patch
here that adds additional consistency.

On total failure - release all resources.  This makes the sysfs
interface consistent with the probe failure path.

Just attaching a fixup here, since technically it's not a bug,
could fold in separately

~Gregory

--Ha7M+e+kLoFbO4pS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename=0001-fixup-dax-kmem-add-sysfs-interface-for-atomic-whole-.patch

From e341860c83fd5d5e8549d8adbf71a484c8990c5f Mon Sep 17 00:00:00 2001
From: Gregory Price <gourry@gourry.net>
Date: Tue, 30 Jun 2026 14:49:06 -0700
Subject: [PATCH] fixup! dax/kmem: add sysfs interface for atomic whole-device
 hotplug

---
 drivers/dax/kmem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 19effe0da3dc..f597d8a99c1f 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -380,8 +380,11 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 		return rc;
 
 	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
-	if (rc < 0)
+	if (rc < 0) {
+		/* Total failure, drop the reservations we took. */
+		dax_kmem_cleanup_resources(dev_dax, data);
 		return rc;
+	}
 
 	data->state = online_type;
 	return len;
-- 
2.53.0-Meta


--Ha7M+e+kLoFbO4pS--
