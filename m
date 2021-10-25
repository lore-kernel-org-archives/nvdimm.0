Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0399C72
	for <nvdimm@lists.linux.dev>; Mon, 25 Oct 2021 16:55:06 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id t11so8337427plq.11
        for <nvdimm@lists.linux.dev>; Mon, 25 Oct 2021 09:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=34KqGsADswDnjonTJQq114bRqQgkKcPCrw08YN12k1U=;
        b=ArdZ9P7fyJ7zJHFYx1+AQE02HbDLJAUvr4erZl2mwbBhtH4+TimE4u+ugqvNFdwh8d
         3/k33Em4/TsoIsweBaglse1QZQgHs7wcFn8ECUkcngi4ODPtbQO4Nm9N6HsFFQgfLYjO
         RePbywXUgZ4jXqcZxI7CJfFNDy98/HjjX5D5DC2BF8G+I/IOB9VG5SIpJ3tDITv0dJRl
         sUJ6d+ibD4KBuChDdczeAcIBzNl30xwnxblX9PJBRPoGnixLoKyw7+/sPO6a5ErIzVMp
         go4JYUYLmAuef1oHBLR/IOfONu/74SlIlF3dwUs57Wqyht+Hr5rXw+CnNSGJhGpEkKIr
         iTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=34KqGsADswDnjonTJQq114bRqQgkKcPCrw08YN12k1U=;
        b=tljeeO4NH1fy9J1hybabj92Vory+YDzQmEZkAPfbo8Oy+mb2UVKXRA8Ghy6u/1rasN
         IfJaqhRnyyan7saAY5ldiUeNUnack+6sOjI9eAJhkq1grvQuBsB3aLN4Wl26VmSTmBuy
         eNIOh/Tt8CoVnRQLaFRktdGtBna8lqugKuFncSsaDtNsN7XC9yyBhRefUa7pG/J2ovMr
         h7AJAR0LxdtlMs8xovrDZ+Ma3NjGYSm6zeXZNUWabWYUPxHm1lmhqAvljIoCxi/Rkjzl
         VbU3NUrB+VGhkcHWmWpZy0NZQzJS7bLHFGiipozk+nYjOfVJFXqpcmwLPZY199+5Grwm
         XVeg==
X-Gm-Message-State: AOAM530/VJfbFm4Lg/GdilsMJXeBOdekl4D25M5hu1CcWMQLEHztSsvb
	WAsbDC5mefn0pr2+Hv76R3Q=
X-Google-Smtp-Source: ABdhPJwnOC5S77AdBEAZhaiGNLZ1LAMQYdWuNPBpW15141iALB0JrDnj2gFivuKTGQtzXuB/cou/UQ==
X-Received: by 2002:a17:90b:1b49:: with SMTP id nv9mr21773068pjb.134.1635180906379;
        Mon, 25 Oct 2021 09:55:06 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:676:677c:1b95:77a5])
        by smtp.gmail.com with ESMTPSA id c15sm9853456pfv.66.2021.10.25.09.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:55:05 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date: Mon, 25 Oct 2021 09:55:04 -0700
From: Minchan Kim <minchan@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: axboe@kernel.dk, geoff@infradead.org, mpe@ellerman.id.au,
	benh@kernel.crashing.org, paulus@samba.org, jim@jtan.com,
	ngupta@vflare.org, senozhatsky@chromium.org, richard@nod.at,
	miquel.raynal@bootlin.com, vigneshr@ti.com,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/13] zram: add error handling support for add_disk()
Message-ID: <YXbhaO5QAOi96E8j@google.com>
References: <20211015235219.2191207-1-mcgrof@kernel.org>
 <20211015235219.2191207-9-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015235219.2191207-9-mcgrof@kernel.org>

On Fri, Oct 15, 2021 at 04:52:14PM -0700, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
