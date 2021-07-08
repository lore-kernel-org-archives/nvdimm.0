Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8783B72
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 21:42:27 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id k20so795350pgg.7
        for <nvdimm@lists.linux.dev>; Thu, 08 Jul 2021 14:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sF2SLv1J75sp7+9Z1D9xVZ2DZMuDJ4EIVCMBTYYdpaE=;
        b=Aucdo1nfTK9WH4YHFO+S0c2jMbiU+rLKBqaY0zjsSpynqLigrfR7DDG70BEKnBjk2L
         LK0dbFuinG4+S9r2tCykcvamS4XykDOrzg5frGug5aTpIdLpovE/Ug35fY89p5rBOmWn
         U4AokinMmygIU+via+i9HWoOQbNobN0leqzxTX268f0SkE+gvP4UFJoIk/4IfZ+mZWuw
         uBw1Ax+QVH9HJWoQYNSax5r4p3wf9EBL60RrHfg1ds7FsTUCgB7uBkgl/58ozBeWrNNW
         6oMAbSk4/hKNWHXVnbqKpz22rSPnqQ4sAunLGji7eWAFuN8Csm0fNqSvD21uDgaEWIYM
         ygCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sF2SLv1J75sp7+9Z1D9xVZ2DZMuDJ4EIVCMBTYYdpaE=;
        b=cFJpLp+lA2nFqXlvyuh3yoMSNO40qUE0+LEUkpdaga5cnBPu8Fe+kvhKDZqqZSuOlC
         B88sCjPmoQvJg96yfZET340TFat3PFvbmxbmax5Hk9ENpIvRfLoXJ6Q5cSj2DsDlqRke
         W87+OHGHlTig1sXPAqg1j7j3lwowG9JZUB89AweCvBQx1JY1ra+qiBbn0yyGb7Aw56IH
         ILRIQgkx9xk2rfnY9b3IDNkJclj6aZK43sNVK4zJNr9slzaL2o6pbZSCNsrJC0vVJABQ
         axo04rLSwZWt2QfNNsR3CzAKfjlCHg0mtKj35oLqOGC2P3kSalMwXYra19vKWRX2PJdP
         UjgQ==
X-Gm-Message-State: AOAM532jzLf4Ia6VAGv8xPS1FcW8epnUQrEx0scQsAWbrR7ukHEVouRr
	gTnpe7C/k5v9vd1qCAeyzELE/Fe5JcX0diRiDHuwI0HQk94=
X-Google-Smtp-Source: ABdhPJzv3zrUckZX0y97aE7n06bPIRIcPuBnKemI5fQhx9cUbdgi2Ux4cZkkFMY7olUk+eEzHWgEkzDp8Y94hOrUubg=
X-Received: by 2002:a63:d54b:: with SMTP id v11mr12860663pgi.450.1625780546940;
 Thu, 08 Jul 2021 14:42:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210708183741.2952-1-james.sushanth.anandraj@intel.com> <20210708183741.2952-2-james.sushanth.anandraj@intel.com>
In-Reply-To: <20210708183741.2952-2-james.sushanth.anandraj@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Jul 2021 14:42:16 -0700
Message-ID: <CAPcyv4j3YWj4Wm9Bu3jvmiQBg8g-Asdb7wOCfZ0rX3bWAwWmPw@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] Documentation/pcdctl: Add documentation for pcdctl
 tool and commands
To: James Anandraj <james.sushanth.anandraj@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 8, 2021 at 11:38 AM James Anandraj
<james.sushanth.anandraj@intel.com> wrote:
[..]
> diff --git a/Documentation/pcdctl/theory-of-operation.txt b/Documentation/pcdctl/theory-of-operation.txt
> new file mode 100644
> index 0000000..b363195
> --- /dev/null
> +++ b/Documentation/pcdctl/theory-of-operation.txt
> @@ -0,0 +1,28 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +THEORY OF OPERATION
> +-------------------
> +A region is persistent memory from one or more non-volatile memory devices that
> +is mapped into the system physical address (SPA) space. For some device vendors,
> +reconfiguring regions is a multi-step process as follows.
> +1. Generate a new region configuration request using this command.
> +2. Reset the platform.
> +3. Platform firmware (BIOS) processes the region configuration request and
> +presents the new region configuration via ACPI NFIT tables. The status of this
> +BIOS operation can be retrieved using the pcdctl-list command.
> +
> +Region types are as follows:
> +1. Interleaved Persistent Memory Region (iso-pmem)
> +This is a persistent memory region that utilizes hardware interleaving across
> +non-volatile memory devices.
> +2. Non-Interleaved Persistent Memory Region (pmem)
> +This is a persistent memory region that does not utilize hardware interleaving
> +across non-volatile memory devices.

"iso-pmem" and "pmem" are not immediately obvious names for
interleaved and non-interleaved pmem. Even "interleave" is not a great
term unless the user is familiar with the operation of the memory
controller. How about "performance-pmem" and "fault-isolation-pmem" as
that is the question that is being asked of the user? I.e. do you want
to configure pmem to maximize bandwidth, or do you want to configure
pmem to maximize the isolation and resiliency to faults in individual
modules.
