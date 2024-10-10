Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A5E1CF5D6
	for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728572405; cv=none; b=vFZZxgdJt39m0vqmXTw45d9zm8ejIAQyHJJvcudxAPqjv2bEtFrK5fMyQHL3L+Bahn5Z7a6ytsQgIMkMc+BNcmYa2J00fMe8fne6UdXF359tmvHxHr50hq8m3LgFbjmcb8mt/jupxd2lT6Nru0MqU1u6kMVmajrCzz/AoNKKqpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728572405; c=relaxed/simple;
	bh=b7V2f907wC3gpJZSILtBNClfTtCPhHfEFBQrnjR7EFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKXYU/SYOj12yrv21kJdxZb9HsVcFpaW1qOVrSaql78DYqdQchMJU+DxcYIxCf7Hc9aQYjHqkeg9lbdYTVUtNaLT94t2l1cnqoRcJwRw3XNVV22AL796M92h1xiv8xTP6wGwXZLoTmpMlN0BG1dqPgcVxAunKQYLeCBRs0mwrAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K5RillMZ; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K5RillMZ"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9952ea05c5so170505866b.2
        for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 08:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728572401; x=1729177201; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XQuFIVPgcDNzzP5dDQ9aPllAbgUFYGZeYMdHPf9KucI=;
        b=K5RillMZugTUwpyKaXO6DLoZvNU6idfTJdPaepGSMAEoYYpSueTuA5Sl+DzIpeTUI5
         Lk8M1uXZExo3du6M5nUtntTbfdhkx26NX8OqF1AiinU+PvcSSEoa3OHakAEWkZLayaAd
         fvHVoG1bcJ8vCO+0+1dDNuqBUYSNm+THYgsILZEepFzUxaju3LO73sjXDjzl0C+Hm3Lg
         ACdWYoXgHrBjdGxAEMfsv3mJJtM2dtsjlWvoX9db8iz1mB8HneKyzcBAYfn80s4taD6M
         Ztc4E6B3GqVOKP+SLzTk0HGSWgfcGCdiIYJPyVckf6g6vIeQM+3eJxb9EalKpyoWnNpu
         xjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728572401; x=1729177201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQuFIVPgcDNzzP5dDQ9aPllAbgUFYGZeYMdHPf9KucI=;
        b=jE+ulIt7GOjsLjL+bNJuPMXkUU7yjRzhndB88f1CHmLUMGBNN24CjnWjTW9g6Q7OrP
         SBnGPrkXUDa8qjSH5drvIvLNauuaSbti/Z66Iydj/lPlwDr3ob8NNQ7+IexBXIHKqAfL
         mDnpDP1LLX8EWFZWaZ3zIjoTbGU4CDxieetE4wm3DdHi2PDgltaWvTd1kyQN9CVYYvYD
         9FXl/xjlT8gTrqvA22tHUZZDFg5LpFkqfIk0x2AHB9ne8jhD4GRhJmFnoJz19QZ3mQPP
         rXyHo825B9ogmeqFJVk/qyZplaahKV03cvEXlNN1kaJqS1E7IGk4j4cwazFUkE4bMUrE
         r3DA==
X-Forwarded-Encrypted: i=1; AJvYcCUuQ3B0bsUV+emwo/Sk7SoteSq7KECmLyeqntMogNWp2KbIMbfh1HX5MVJOU7k8X7OvJf7u3LE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhTCfpQtz3mXZueW7Mob+eh3iRsyJNaWPUr5A4kGpCkaKbsvZL
	/Uv2Tq42t3VQxzFVBn29FLHHy9xb61DoFLiGDf2QE6iT+xnD/QPRlRIG/9h/nTw=
X-Google-Smtp-Source: AGHT+IGW2A85HxaygCEijBG35Zwt3g08r3KbMHbf8XGM1RPwC0Ld8GCukhWd13kxEHGSwGXTGCl7Iw==
X-Received: by 2002:a17:907:e654:b0:a99:585a:42a9 with SMTP id a640c23a62f3a-a998d117cb5mr585547666b.9.1728572400859;
        Thu, 10 Oct 2024 08:00:00 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99a80ef972sm98465166b.193.2024.10.10.08.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 08:00:00 -0700 (PDT)
Date: Thu, 10 Oct 2024 16:59:58 +0200
From: Petr Mladek <pmladek@suse.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v4 01/28] test printk: Add very basic struct resource
 tests
Message-ID: <Zwfr7na62OKIlN8b@pathway.suse.cz>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-1-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-1-c261ee6eeded@intel.com>

On Mon 2024-10-07 18:16:07, Ira Weiny wrote:
> The printk tests for struct resource were stubbed out.  struct range
> printing will leverage the struct resource implementation.
> 
> To prevent regression add some basic sanity tests for struct resource.
> 
> To: Petr Mladek <pmladek@suse.com>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: linux-doc@vger.kernel.org
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Thanks for adding them. They look good:

Acked-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
