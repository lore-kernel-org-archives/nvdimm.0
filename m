Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4DE3FEE
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 21:10:44 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d18so1917546pll.11
        for <nvdimm@lists.linux.dev>; Thu, 09 Sep 2021 14:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VG1c0x+0/lVVOXIHX3HpgQkWwFlp9iGDH9PblGIsiAk=;
        b=EyRlvOY8RpnBWH5Nbr4sKz/zrlu2CSQocU0YQiaEjF5OoXFMfbxS2pQZMfAXGMXIfv
         erHLWdHJOOBhDOIqrznjhwBddqBIpjWNM3JvkFcHvRmGPMAv8DK5gzNjP1EypQPnC9hD
         aRBPLIXAORFW0R8f1YUGsVAxGum/gwB3/a+23ZHLMBVPYS4+9NKvNPCh4gmVjwskmhnS
         ecq9gnqeAA6cUwiLc11hHD1aFF/VlEqIER/5/fs22oQ4Il4TLxsvCgtT2OE2nGnWspw1
         Pg8jkIb2tUOyMKqBxG2VNKn7JYI0S4+3+4sjpFw6GJ8u0BtquhuCVLlw9nZwkzwOP4mu
         W8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VG1c0x+0/lVVOXIHX3HpgQkWwFlp9iGDH9PblGIsiAk=;
        b=nFoc0gjYereZ+67lA/DCyqTqcWw6BfuPJhrZltj8sCqijP8xoviQ12QWWW2+J77t9O
         wQcuVSOrF59W69xIZNTECxk1TfE68kWtna3bWTrXs8MnDdRyO4FC35ZchAfuCT8Z+2VR
         J7EdIBOJom2mC2ixSE+j065Dx87TK5wg2KpGMmp6NtveeZ1pkYd9rqjfr3Wvt7K+FxAF
         NHh9vFkiY6rRBHATt7/LS5MThzG1bY33lPskXle08HuXSuslDCXEnPguMdOJIslo+Nsw
         GHmlNs1qMoIU0ypXtYZ/BZk+TSP+AoethaN+gwmNV59ujha5UvxCm4cVU0HoCn9OKLLm
         y4Mg==
X-Gm-Message-State: AOAM5300Qo4jCnm7j9MgM2c4lNfJC0rBiYi8Y9Ey6I+jCDjI0vNL9olh
	/tqpo5XJxJGMYkub7FPNXabCSWA5tOkOs8mTMAO6xw==
X-Google-Smtp-Source: ABdhPJzlxcCP7Hb984HZFtYsiJ0Isrx0l8Uh6HhNFtFSwIMpAEt6kIRDehsecyRJmVHfOo4UQRQZuLiRxY+agEjLV9U=
X-Received: by 2002:a17:902:bd8d:b0:13a:8c8:a2b2 with SMTP id
 q13-20020a170902bd8d00b0013a08c8a2b2mr4427221pls.89.1631221844391; Thu, 09
 Sep 2021 14:10:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116433533.2460985.14299233004385504131.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210909162005.ybqjh5xrbhg43wtr@intel.com> <CAPcyv4h3LmmpTt_0Om0OCxWPXo-8jucA-9p3rwhx_j2vCFEj9Q@mail.gmail.com>
 <20210909210527.eyxreaq2vim3wfps@intel.com>
In-Reply-To: <20210909210527.eyxreaq2vim3wfps@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Sep 2021 14:10:33 -0700
Message-ID: <CAPcyv4jFcEgbZBrBpDZJ+ciyaUz8ev3xj2A3kaDAOcgTCM6V2g@mail.gmail.com>
Subject: Re: [PATCH v4 08/21] cxl/pci: Clean up cxl_mem_get_partition_info()
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"Schofield, Alison" <alison.schofield@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 9, 2021 at 2:05 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
[..]
>
> Caching is totally fine, I was just suggesting keeping the side effects out of
> the innocuous sounding cxl_mem_get_partition_info(). I think I originally
> authored authored cxl_mem_identify(), so mea culpa. I just realized it after
> seeing the removal that I liked Ira's functional style.
>
> Perhaps simply renaming these functions is the right solution (ie. save it for a
> rainy day). Populate is not my favorite verb, but as an example:
> static int cxl_mem_populate_partition_info
> static int cxl_mem_populate_indentify

Sure, I would not say "no" to a follow-on cleanup patch along those
lines that brought these two functions into a coherent style.
