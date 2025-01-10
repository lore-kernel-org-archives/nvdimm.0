Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737171A9B4A
	for <nvdimm@lists.linux.dev>; Fri, 10 Jan 2025 06:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736490961; cv=none; b=IZ6OJ8/LVsE91tBEgO71SkmlkHALxyqFxoA16gQiITYX/dotRFVh1QxpDsbbaz7Fj01eMdRS/c9NFGjyBkch5sMPK9fd77CkuMwEtOlglfIT32dVknNjcmLO8XEkpqW6zq2SHeMUC9gGQnQx9gstw4GcapQ4oYrubNaeVfqMLdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736490961; c=relaxed/simple;
	bh=gNoZjmXMTGaHco+cxD/Jb6GHTsnaytjcf9LRxYDW07s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YTBzRTHv/GPfpJUp+l469wMwyhllphJrZRfULOVlHCAUrSmxQpxQm7JezghkX3Gw45iVhfpT9Au2ciTxC8QQHQjMH6+CsRj7/l5K7Z6KYCoJKiYA/YDKIDP9E2C1gYl6DJnd0m9dMdjodZUMfi9HKz/ZRUj2qhzf81WAQHk+BbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pi43INME; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pi43INME"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-38637614567so854726f8f.3
        for <nvdimm@lists.linux.dev>; Thu, 09 Jan 2025 22:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736490958; x=1737095758; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ltp5c9SQJJwLa6Bkc/1r8Fhm7xJG4V3DKZrPfgONzBY=;
        b=pi43INMEhaQ9kMI6jw3pZOw0TdtPRdhroFRgHDxWkvQ9YQWFbHTbdPRdkCr7Ahk48+
         N9TSGu/mGiccmgqpBylPD8RI8QQ4A2srFPGLH7hAEEplKKq7cPOLJ56MVGq5GRtLN4ry
         Wsnek14H16ZOSD4/JeIjo2ceumVOMxH+VGqB61b7ar9bkRWtuA1kHaJqa6ilvScYmwTA
         dJeAMv1UzxDh7M4K9V37/KLcctdFj/h8ubpXaDfdJ3PNbvm1l0+aTBtSIVb1wuhxUyiF
         are+K2RqGV8tUiztT87Tvt7Vwsyf8FNILY6YDJCSDvgyoYb2eSM1n7mr2rX7/eI9Lov0
         2VgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736490958; x=1737095758;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ltp5c9SQJJwLa6Bkc/1r8Fhm7xJG4V3DKZrPfgONzBY=;
        b=ZIuukSbm4MILXRnjkDV+IFWPhOR0JB1Hx6azaIrvfr2eUo/z2rnF0+68EbDE+8h/hv
         6DKfgVL9IakL1vE984wy5rInQ7ocANnHAx36nNjeKBdA2SNa+0GyHlHBEpUMFCInbutZ
         iUvKygn6LkmlBdathcOCEWhx0TVktHInhW7bMftHjfb1db1Z2c6xjqkczuGuNSeufPTX
         T9xzNU8cj3MXrFT70Rdvdqixflvoz00ootctJ4JnsS6VCvSiVFrhafcIZuvK3iM/rN5p
         4Non19JCSoQQ7pI5TX0ukvS4fdb8z6CH1Nx1z0LrEThKGJdgjyILbQhTMfsjSq+ox46Y
         y3PA==
X-Gm-Message-State: AOJu0YxSRM4PQu7luO/YuAhOXp8Ylf2982C2Z7P+eimFr390ePULW6uP
	4dmDMronwTd/7zZ6bwE+8wMugwgEeM17j0Ws17X8rZz8QV9voAgU7VprUVEeACKLaxHFNdwguOD
	W
X-Gm-Gg: ASbGncvLVGZYtiHSfOWf1eMsxMuBeQYtEMaTnwHLpKOgxLOptHu0SUDEtfoK/wj3MhO
	T5Zd9isc8b4EplpaAP8Xszw6L0zTyBjZ/7Irs90sRmfuXb93NPaPuDWdeHC0TlvZscXCcENku9Z
	7eHoNDG1zy8V3kF3GaLg34f6OHyXfS3DVKQwxTWK1BKsaGNa+5nNFTXBb5q9eCU59q/k2b1n1c1
	0oeIBIlZDYD1FSxC3EgtsnG8SGhusbrjyIJkrwXvOg3xK1CPTSCpK/utM5OlQ==
X-Google-Smtp-Source: AGHT+IFoCHVs2/tXoGdNPIM9GoyDCEW/KR44zfp4vkpZwOu83VQyNxWQGHSyWlWBTnCSjGdIu0lbNw==
X-Received: by 2002:a05:6000:154f:b0:386:373f:47c4 with SMTP id ffacd0b85a97d-38a873579b3mr8228780f8f.49.1736490957811;
        Thu, 09 Jan 2025 22:35:57 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e37d0b1sm3679168f8f.12.2025.01.09.22.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 22:35:57 -0800 (PST)
Date: Fri, 10 Jan 2025 09:35:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: nvdimm@lists.linux.dev
Subject: [bug report] fs/dax: properly refcount fs dax pages
Message-ID: <1a5de319-a33b-4264-aec0-ffb1283b6ee9@stanley.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Alistair Popple,

Commit 9c4409f51aa3 ("fs/dax: properly refcount fs dax pages") from
Jan 7, 2025 (linux-next), leads to the following Smatch static
checker warning:

	fs/dax.c:379 dax_folio_share_put()
	warn: unsigned 'ref' is never less than zero.

fs/dax.c
    370 static inline unsigned long dax_folio_share_put(struct folio *folio)
    371 {
    372         unsigned long ref;
    373 
    374         if (!dax_folio_is_shared(folio))
    375                 ref = 0;
    376         else
    377                 ref = --folio->share;
    378 
--> 379         WARN_ON_ONCE(ref < 0);
                             ^^^^^^^
impossible

    380         if (!ref) {
    381                 folio->mapping = NULL;
    382                 if (folio_order(folio)) {
    383                         struct dev_pagemap *pgmap = page_pgmap(&folio->page);
    384                         unsigned int order = folio_order(folio);
    385                         unsigned int i;
    386 
    387                         for (i = 0; i < (1UL << order); i++) {
    388                                 struct page *page = folio_page(folio, i);
    389 
    390                                 ClearPageHead(page);
    391                                 clear_compound_head(page);
    392 
    393                                 /*
    394                                  * Reset pgmap which was over-written by
    395                                  * prep_compound_page().
    396                                  */
    397                                 page_folio(page)->pgmap = pgmap;
    398 
    399                                 /* Make sure this isn't set to TAIL_MAPPING */
    400                                 page->mapping = NULL;
    401                                 page->share = 0;
    402                                 WARN_ON_ONCE(page_ref_count(page));
    403                         }
    404                 }
    405         }
    406 
    407         return ref;
    408 }

regards,
dan carpenter
