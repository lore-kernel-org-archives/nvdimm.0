Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89EA38FBD
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 17:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tzDIrk35"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3247d69ed2cso1246527f8f.0
        for <nvdimm@lists.linux.dev>; Thu, 05 Oct 2023 10:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696527346; x=1697132146; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DjV18W14VGFP/nPsNY3gbJ8MeDRf1lFLKLsprrYEXF4=;
        b=tzDIrk35BKfROO8TwGOhZ7WKbLYstw96YJcl2I4VtFc21USlFasSflPmLAox3LmRHc
         4tKhfrvb+G+QtASns9SVJwvbsx+xUG3cOVC/jdYnZL3I3zOJsiV9SMl0XyBfy5DW8scr
         TNJKV5xRQchjTGrrmjnlNDN9E54NNbmQE5IuYjjJ3QvuLcci8eIxlDSncaJwMQRo4V+F
         RZzRZ/Hy6ACA4QvV0GIYNFaM9mxvCAXnUtczBt6GtHrAOqkK6UV/8HKocfmOxeplhe9T
         HFCFybpUscmsp6p3QGvYCl2cXuRncafcRCsPZ+PeYTT3eh5lPRQxX4eRCWpOj8G+aPyN
         jaUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696527346; x=1697132146;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjV18W14VGFP/nPsNY3gbJ8MeDRf1lFLKLsprrYEXF4=;
        b=GrNJW0ucYV6lPBBr9EixAK9TUQ2oakkaoogIRLl4CmbwuG3WFGz4hlFKQRPoAoYL1z
         3NsTFNLc5GRfGdcwrCS19Yn+ZttQfvmOwhtgTilUpBgunrNuhZSOvE0jlfNDzJ49kCYg
         OxXKd94j+eX3AvX6gdj3A312xyYKzoURp9JJl+Vi8cjuQtrKqcBwStTMg7JdzSaLRQXs
         0E9lZF2iWTJkTMSTcduY/5Qs09OUBthl8vDagdYDgPQLApWPEmCxGkT7crAeVzS+Vl4C
         DXT6j+i2P5mxI1V5HP7onPX9namAG+HRk/BQhSjhMaJ9U9bBwQFAQjWX+a7cLm9+eyiy
         UcQA==
X-Gm-Message-State: AOJu0YxgXx109jy8I8OL89OY4iiRY4wyaTP7MfTN8JKOnTUuYWTG1AXC
	SGHZ7H+LJxaXd4BBjVkgURa3uA==
X-Google-Smtp-Source: AGHT+IFmcAEhWMBTM9kJv/GJNm6kTZFgP/zz+kPOVn3qP9dzEJqrpUFektXsZSq94T8eVCfCO0byMA==
X-Received: by 2002:a5d:4b92:0:b0:31f:ea3d:f93 with SMTP id b18-20020a5d4b92000000b0031fea3d0f93mr5783055wrt.40.1696527345789;
        Thu, 05 Oct 2023 10:35:45 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id b2-20020a5d5502000000b00323330edbc7sm2249544wrv.20.2023.10.05.10.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 10:35:45 -0700 (PDT)
Date: Thu, 5 Oct 2023 20:35:42 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] dax: remove unnecessary check
Message-ID: <4a73c30f-ebf8-418c-be67-420302641153@kadam.mountain>
References: <554b10f3-dbd5-46a2-8d98-9b3ecaf9465a@moroto.mountain>
 <21381c1e57c2fc2aa7579d4655ea7d3f1c74f6a5.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21381c1e57c2fc2aa7579d4655ea7d3f1c74f6a5.camel@intel.com>

On Thu, Oct 05, 2023 at 05:17:17PM +0000, Verma, Vishal L wrote:
> On Thu, 2023-10-05 at 16:58 +0300, Dan Carpenter wrote:
> > We know that "rc" is zero so there is no need to check.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> >  drivers/dax/bus.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index 1d818401103b..ea7298d8da99 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -1300,7 +1300,7 @@ static ssize_t memmap_on_memory_store(struct device *dev,
> >         dev_dax->memmap_on_memory = val;
> >  
> >         device_unlock(dax_region->dev);
> > -       return rc == 0 ? len : rc;
> > +       return len;
> >  }
> >  static DEVICE_ATTR_RW(memmap_on_memory);
> >  
> Hi Dan, thanks for the report - since this function is only in mm-
> unstable currently, and I have a new revision about to go out, I'll
> just include this fixup in it.

That works.  Thanks!

regards,
dan carpenter
