Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E27168
	for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 12:26:29 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id go30so7133481ejc.8
        for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 05:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9tKYqZCx0Xa8NZjTPlY9d4/gNjc4rJmvJ03vsAxKTEQ=;
        b=jQDsi4nt5OLmFldOi66LtHrs14Rb1Y65Bp9+K3jBpx2yqMqm5FRctNTwlNLgo6uo+B
         jP9CDg7tLBJLLyP7Owegy4CYq+AdMHiTx7oehWHZdLOLkZY/EmH3akn1d53lBVJq1j5o
         2GpKl1Taby4sHLpfe30OWVdWUNMPRLj2KcIn4kGtLTDRpPrBcVMV2aPWHKKfK+u7B5S5
         2xGXEFS4VPvRO4ywEOvKOExx9R6XP+Nr/csPukfh1QduXoJXu92c94E2lUS19Z1m4t47
         juMLGkuK3aoPXu5VSDwqxj7cWQvhK7GSMWLvH63koHAmlj1hwcXcpl9XaySMl6Jqi8J1
         MlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9tKYqZCx0Xa8NZjTPlY9d4/gNjc4rJmvJ03vsAxKTEQ=;
        b=YqbBo8fnlg+ngYtTAMvGL3ypCN5iwY9PS+DCORMzA6+9KdKp0LNzHsN9HfxPdeLUA3
         NpYkyoTrhRuScrhLPtffKV88I1RDcFY3xljjL5Wz4pfNBTk8U+S/H9ccuMzW4Sw3ey1u
         lTLYJB30+pAsymfxRx9mIPVhKVsKRNtRs5rSm67XwSg+FuYgcveCSpeZq0OQe200a/P5
         +YRwEKTMc3qqCt9Ywr30EIHEIB1nVrF1LjUWeDPuevRQBnuFTIxogEDaqRzetZ3a0tPO
         5yKd1IQTJIEkB5pSgsWHyLwS+KT22KYQPdC45dl4QQb3a8jwwifCIsMDnd6YF/q47tcY
         AmoQ==
X-Gm-Message-State: AOAM531/tUsQdrIy4+nvNqpaNiVNQ/XEJh7RZSFaG1ixJMgbSy0xr7uQ
	+zfEQNiiH+lct8hZkc6MVjg=
X-Google-Smtp-Source: ABdhPJwLbZuqx2o+foJWn/jZoO/LZdwL87GxnEYk9pCaoENhX1v26PIprVBepTo1ez4As2e1duqdxw==
X-Received: by 2002:a17:906:2bc6:: with SMTP id n6mr52738932ejg.256.1626092787875;
        Mon, 12 Jul 2021 05:26:27 -0700 (PDT)
Received: from pc ([196.235.212.194])
        by smtp.gmail.com with ESMTPSA id p26sm6191169ejd.80.2021.07.12.05.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:26:27 -0700 (PDT)
Date: Mon, 12 Jul 2021 13:26:24 +0100
From: Salah Triki <salah.triki@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dax: replace sprintf() by scnprintf()
Message-ID: <20210712122624.GB777994@pc>
References: <20210710164615.GA690067@pc>
 <10621e048f62018432c42a3fccc1a5fd9a6d71d7.camel@perches.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10621e048f62018432c42a3fccc1a5fd9a6d71d7.camel@perches.com>

On Sat, Jul 10, 2021 at 10:04:48AM -0700, Joe Perches wrote:
> On Sat, 2021-07-10 at 17:46 +0100, Salah Triki wrote:
> > Replace sprintf() by scnprintf() in order to avoid buffer overflows.
> 
> OK but also not strictly necessary.  DAX_NAME_LEN is 30.
> 
> Are you finding and changing these manually or with a script?
> 
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> []
> > @@ -76,7 +76,7 @@ static ssize_t do_id_store(struct device_driver *drv, const char *buf,
> >  	fields = sscanf(buf, "dax%d.%d", &region_id, &id);
> >  	if (fields != 2)
> >  		return -EINVAL;
> > -	sprintf(devname, "dax%d.%d", region_id, id);
> > +	scnprintf(devname, DAX_NAME_LEN, "dax%d.%d", region_id, id);
> >  	if (!sysfs_streq(buf, devname))
> >  		return -EINVAL;
> >  
> > 
> 
> 

since region_id and id are unsigned long may be devname should be
char[21].

I'm finding and changing these manually.

Thanx
