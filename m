Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A9B2F26
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 02:31:31 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id j4so595288plj.8
        for <nvdimm@lists.linux.dev>; Wed, 09 Feb 2022 18:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aLU6bPsZGwHyJVYo5jijI5LLvxPp0ukTfd7CbOJ/NgE=;
        b=1gPR/XwlCx4OMGXXJU7MQyj/rxq/jnNRh6uuQ23p/FE3uS4f0K84BWQCnEll9HKGmU
         lwNNMWOXLU8++FJMCpz/PFh0Qij5d7LEafjiFcwtWDbLdSKctEh742g2WsE/2eQe1jDH
         aA0RLsps+FRqvw4Bnia/7rfeIPSc7G04XbsJj4/OogDZ884mBRIFJibgIPnNIYzsXGts
         Q3IQoGaBTP7g8pHWOtD67hP/AI8M3uHErBtXVZXf7z1Bzg0rNVyZpTtpLPYasJm2WDR4
         nRSz16UtaNxtuEmXybqQNWXY33EmtmZe8txMyRVzUqqbT/Nqfwlw6rmiMRrIZ4ySoLgK
         21lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aLU6bPsZGwHyJVYo5jijI5LLvxPp0ukTfd7CbOJ/NgE=;
        b=SuV7N/dEAGFB65iT42ZaXXkbnw4yTYhICU9KRUEVJJ9H0POa4tlG01tO1isg5/DRwB
         sviUGAcZPUHWM/TFDkIKFS1ucQHKyOVvuw9Ebog5Yu6aGh5kgT6hL2cHIjLBabPviSWl
         9K09ZnuuWJQA6xIIhU28DF2egBdLmFiqRatPD5CpOxs0sITPKoGkN3RYExlt6WvfAmrt
         zmgAX6upghkuzglGVfA66vxQcUFApFcoooVrMXJ+bQdFdeCvUEk8krvvXngMzp4vrR5w
         vpIXXgt6/KF5EEoFnsm+Eh/M5dI7lG8Kanb0hhs1GCUDnZx1f+Rc7dgupWRtEIuERCod
         ksgQ==
X-Gm-Message-State: AOAM532uZF25yg/ascvVuSYfS6JSCWWVek4dXK/EKjaEmizhc0Cap1bL
	ypgcCGaBsJc/UeKHo6EZWHfHA+zWxmOtAkdN9D4Lnw==
X-Google-Smtp-Source: ABdhPJzw0AlnVafRcyjp/Apr9rZF4CssYrKz5N6PYFuCuuXopJUi5OOtMhNYhQpqDCdEzCg68kR3GkNAIJo84LNmaWE=
X-Received: by 2002:a17:90b:1bcc:: with SMTP id oa12mr392524pjb.93.1644460291091;
 Wed, 09 Feb 2022 18:31:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1644455619.git.alison.schofield@intel.com> <6b937b09b61ddf95e069fd7acfda0c5bbb845be8.1644455619.git.alison.schofield@intel.com>
In-Reply-To: <6b937b09b61ddf95e069fd7acfda0c5bbb845be8.1644455619.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Feb 2022 18:31:20 -0800
Message-ID: <CAPcyv4h2DhDjJZPj25Fs9=VqLAHa75u7MzCOsS5wm_BBnyXUvQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v5 3/6] libcxl: return the partition alignment field
 in bytes
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 9, 2022 at 6:01 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> Per the CXL specification, the partition alignment field reports
> the alignment value in multiples of 256MB. In the libcxl API, values
> for all capacity fields are defined to return bytes.
>
> Update the partition alignment accessor to return bytes so that it
> is in sync with other capacity related fields. Use the helpers
> cmd_to_identify() and cxl_capacity_to_bytes() to accomplish.
>
> Since this is early in the development cycle, the expectation is that
> no third party consumers of this library have come to depend on the
> encoded capacity field. If that is not the case, the original format
> can be restored, and a new _bytes version introduced.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
