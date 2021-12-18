Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3042F168
	for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 15:39:37 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id d11so5110684pgl.1
        for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 07:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GtzOvYH5p4oHhKuIxV9CTKLQYBz8qYYVfThW6YVEmB8=;
        b=g4oak7tiZEMvmbf5NIg1Qu+WML5g+rmFggtZOhDsFSADSCNHOm1pDySAERD3jVcd3y
         lNPJDhj8lX4sgQ6zMDmN772CZsbL1pdgMENnipZiFwBSHP1VGy9UqVIxXUeaGR3EdXTh
         pmbEfPwQuhyM++lRlTz0bOKMDJjNM9aIvzotq+agjvoAMpEUuyRkhlMav0UbbVg0ajRL
         S73SeWyarSU0Ri4drekQ/S2F/3ZD70VWH0pGp90oDTEMS/ZsHCKOFCQDM8eOePiP4kEp
         3r+nicwhPlD0queAv9DHoDSGhk29spT+ErXGHnkx0aE4HPSwaGweemvba4T1VwN5pcod
         OEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GtzOvYH5p4oHhKuIxV9CTKLQYBz8qYYVfThW6YVEmB8=;
        b=7BB8YtGbc63hcGb5ao+dqeI4TKqfrj2nIUBG7ykpFUQTlhN5xLJ+NIghOkRGdhiL70
         7xm7Q4aKfdpIcTeyYztsfMVKD8g7Ux8zQrYbuV3tMcU+S566l1fPTdMXcazfCFypMi4Z
         OK+pMIqZs9IjJAPQmF3iZmanhKrSDIfKOC2211bQgMLW084hvyBLUcpt9WNQ8UvmTJS4
         U9zlIgqEs31lDAN+oG0280EeVnQRsw0+vj5GSpXjD4p1oinxrSa20wEVyZcZAuLA6zYR
         MhXxLQDAI0r6DPLfvCkWFQGE+kwEbVI7Exb1V/mKxxa1zR034mjpPD3vHT46Opt/ZDGz
         OpGQ==
X-Gm-Message-State: AOAM530PsmAnRqU/kZelhzBa4oU4eAw3SrI3MClLCVPoswuaxhB00Z7P
	GRpWhhQjL9MFkJ7q9yfnOag36MAfcbRF1u40YFFlSw==
X-Google-Smtp-Source: ABdhPJxxWpmLW8jB3nneMJcnt2PXAltgOYOrMBen1V7ROZG/s18DzLOezW74e+0O+xknRbDhnP064Hv9dqsrSEzmAN8=
X-Received: by 2002:a63:5357:: with SMTP id t23mr7400993pgl.40.1639841976466;
 Sat, 18 Dec 2021 07:39:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211218044805.443784-1-vishal.l.verma@intel.com>
In-Reply-To: <20211218044805.443784-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 18 Dec 2021 07:39:25 -0800
Message-ID: <CAPcyv4hn5BtKigQQDfZokrcBpC2586R6Egt2iygtk7XPjSrObw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: Add a dependency on 'iniparser' to ndctl.spec.in
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 17, 2021 at 9:41 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The commit below neglected to add a dependency on iniparser in the spec
> file for RPM builds. Fix that now.
>
> Fixes: 4db79b968a06 ("ndctl, util: add parse-configs helper")
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
