Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A424F1855
	for <nvdimm@lists.linux.dev>; Sat,  8 Jul 2023 08:40:41 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-31590e4e27aso218002f8f.1
        for <nvdimm@lists.linux.dev>; Sat, 08 Jul 2023 01:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688805639; x=1691397639;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bg5jwRfmaxJRk/T1b94KrbyPwszc1sFgHMz8MsKb73A=;
        b=KuLEahlqLjG9N9ynMwwryTLykWK0C1O4nb4tV6Nyd8Z1VukEmWA+yE1yME31BU+N7G
         oSgmhbvb2AVxKEqVKiYaQyvCCkTTS40l4+wKIK+OcvdxyGAuftJ9YZZL4yizuPxz/4iL
         rk+e7ofz+hRPM9LZA5fjLhjVkLnsOeNPhqZ7qizeXggEOJCKZRr0uFxnzAZWWNmqqz/I
         wb4lyBl+JmdtmiLg4caEu4l4Clj1i3Ky4i02Aw9YPhasAjzyWDmaKLKKL2UEl5tK6Wml
         tLTkCkMNCuTRkvkVkMMOKmSOSlDBN9++isDplTDU+FqzDFP3hMb3Po1tiGnl3+6FcDll
         989A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688805639; x=1691397639;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bg5jwRfmaxJRk/T1b94KrbyPwszc1sFgHMz8MsKb73A=;
        b=SWElgExj/i9Om+D5LDIwtMpMl7FdQ54Rs+MYf6OudtPS57z1GcpHQANqE02eaUCpI+
         9IPX6a2lh+zerdkfYGtOwBxwy/y+Ww2cOFmf1iXZMwKIuQR+8BgedV/cn0HnVqwdpu3c
         CJlZn2Zm/eqyqaTKPSNpYxYxspTUatFGR0rOz0qoojgUZ3oItyPGWj1/54ggVfaAlfLt
         WJCp8ezZXaaYJ8KKvemg5VLtK5+yX1h9QMoOhWmbAMmxuxHVCw/rs69Jc/SIpcomrLz5
         BB0RYuYIF7T/Z41C/GvsshGkylvFiM+EJzGzJBKUXx65QcmM9+r9E+85ciukm/aG0kiW
         CIEg==
X-Gm-Message-State: ABy/qLYsgS7AcgH5cpChJ+G35Y5XN9FHUii3x5T365qa7RNrW4hrOJxO
	P1Jg5XncecP5LQSjwKkN0e3wBg==
X-Google-Smtp-Source: APBJJlFoVPJ3B4K8Pa8lNU17PaAUd3p7Q58KQeKPARsyfui27A++FIfLqqPcYBLcwWaNd59JeyxWUw==
X-Received: by 2002:adf:f210:0:b0:314:2fdd:28ef with SMTP id p16-20020adff210000000b003142fdd28efmr6416684wro.18.1688805639308;
        Sat, 08 Jul 2023 01:40:39 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f14-20020adff44e000000b003142ea7a661sm6451034wrp.21.2023.07.08.01.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jul 2023 01:40:37 -0700 (PDT)
Date: Sat, 8 Jul 2023 11:40:32 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: dan.j.williams@intel.com
Cc: nvdimm@lists.linux.dev
Subject: [bug report] libnvdimm: fix mishandled nvdimm_clear_poison() return
 value
Message-ID: <90d3d353-28e9-4f6d-b141-a9b7157d5514@moroto.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Dan Williams,

The patch 868f036fee4b: "libnvdimm: fix mishandled
nvdimm_clear_poison() return value" from Dec 16, 2016, leads to the
following Smatch static checker warning:

	drivers/nvdimm/claim.c:285 nsio_rw_bytes()
	warn: error code type promoted to positive: 'cleared'

drivers/nvdimm/claim.c
    252 static int nsio_rw_bytes(struct nd_namespace_common *ndns,
    253                 resource_size_t offset, void *buf, size_t size, int rw,
    254                 unsigned long flags)
    255 {
    256         struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
    257         unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
    258         sector_t sector = offset >> 9;
    259         int rc = 0, ret = 0;
    260 
    261         if (unlikely(!size))
    262                 return 0;
    263 
    264         if (unlikely(offset + size > nsio->size)) {
    265                 dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
    266                 return -EFAULT;
    267         }
    268 
    269         if (rw == READ) {
    270                 if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
    271                         return -EIO;
    272                 if (copy_mc_to_kernel(buf, nsio->addr + offset, size) != 0)
    273                         return -EIO;
    274                 return 0;
    275         }
    276 
    277         if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
    278                 if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
    279                                 && !(flags & NVDIMM_IO_ATOMIC)) {
    280                         long cleared;
    281 
    282                         might_sleep();
    283                         cleared = nvdimm_clear_poison(&ndns->dev,
    284                                         nsio->res.start + offset, size);
--> 285                         if (cleared < size)
    286                                 rc = -EIO;

cleared is long and size is unsigned long so negative error codes are
treated as success.  We know that size is in increments of 512.  Is size
== 0 and error?  Maybe it should be:

	if (cleared < 0)
		rc = cleared;
	else if (cleared == 0 || cleared < size)
		rc = -EIO;
	else
		badblocks_clear(&nsio->bb, sector, cleared / 512);

	arch_invalidate_pmem(nsio->addr + offset, size);


    287                         if (cleared > 0 && cleared / 512) {
    288                                 cleared /= 512;
    289                                 badblocks_clear(&nsio->bb, sector, cleared);
    290                         }
    291                         arch_invalidate_pmem(nsio->addr + offset, size);
    292                 } else
    293                         rc = -EIO;
    294         }
    295 
    296         memcpy_flushcache(nsio->addr + offset, buf, size);
    297         ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
    298         if (ret)
    299                 rc = ret;
    300 
    301         return rc;
    302 }

regards,
dan carpenter
