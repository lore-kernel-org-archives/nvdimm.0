Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9022905
	for <nvdimm@lists.linux.dev>; Fri, 10 Jan 2025 07:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736495278; cv=none; b=u4xLPMyRGS024T48tumjKexhWgRPmHmp5iXANICud53OdGVVMbXRFTLFSrCS+EL6QhJEI+DPlkxG1BDv4XrNcdSXbo3Su3sKb6w6tLYb23GJefQkZrWD4WzD0cmC9xapAyBY9hFxpptHlDtmFcPtfZox4CDAdBxvVXqVY2dE0jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736495278; c=relaxed/simple;
	bh=IQsxXlLK/5Jm8/mkWMCZgNY9m3pkedUpJfeLVqMv4Og=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BB5LXEjz/C/QfP8/ntwkfYj8qpPlbpSIPlLzrrblqqCy7Zc54KSy7dMXfKuLv371nqNEuq8fGCniAsZScH5eIdc7FW+P6/mK4e6DklXRQ/GoBusLOHf8sdLntW0rsDqV9reQD6jSf7J5d91J/4D+3lWCgMuUiRkWfyZzqyA5emk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yzdRO/0H; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yzdRO/0H"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-435f8f29f8aso12962885e9.2
        for <nvdimm@lists.linux.dev>; Thu, 09 Jan 2025 23:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736495275; x=1737100075; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wgCfrZCZvyZFCQn75cJMLPhCNMBSF1Rxx0HCU9rUYWk=;
        b=yzdRO/0HxPhUkJZ6s3s5GGZtkXbPTUmFv+LmnC7xAM9fTWM32f/JrhFbWUmCTg4oGA
         EaECUFFL55P7Y+gWatZw7RGtxbkbHSv10EO8G5YqJ5zzr0kwOKKA7fOk7I1SWUUF3vDQ
         hV0FVVF2GKIssyCxRldRiqEByHqG0d/mykeCE36ukKIqF2wKDopQBS2X30ilA3qsN4K2
         3eqhG32vJXyXk09TcunLheQUBlaBQLL7nxfhmZZOY7EBIK7FY0FaNNjuzpttIdG0KqPK
         Av14WU9XpTvEv4SRhQUpBXWpB+ZyniI8n8ZgEStiMiN0TxSYV0hFCPIj36HVsbtWmeFN
         G/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736495275; x=1737100075;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wgCfrZCZvyZFCQn75cJMLPhCNMBSF1Rxx0HCU9rUYWk=;
        b=A0WVlRSoU4YqXzWocLBmnYfcKgow3MRRz7Gj4atVIH0t3Q1dPQmrwS2ZepKEtqMiQ8
         0Ap76S403YNUpXcyLa+ePntfsCpYBwsg0bi4ou87/oM/MxeBpf6FswNxqVaTJY3CoD/m
         CzSQVxWUUa0QAArZwO/zwQXx8voHqxhDwT1hS6LC1J/LSDg9zxcalBaGgjb/QYtnL6/3
         pyOveVSuepmf6i+yIaE28HH0/AWfis+dQ65jIoGEtEe/V1b2lXFId6En3yiWhPQ2A0mN
         id4KZinb0XPRYnPl7cW5cFBJSt0AhS784ooZUntm6Iw3ZZBlPE5jnRO7gCpF5d9585WT
         6SUA==
X-Gm-Message-State: AOJu0YycqXc1PP6Od+LyqQRiIG7IYMtqDGpsvCqhdMqp1pti/YLcs3hE
	1QyJj9EqkY1F8h9DizUS8awAgsjaqY66JmvE+/VZwIqhsotqvj8p0Cx+3CcOTwA=
X-Gm-Gg: ASbGncvP0xEfkMJZ0Z7DVWsVzu/qjqwT1mj0fG4uyhi8YLKiqwvlmE3Y34lD8YNJeHC
	Tuum5zFZPkeh8YC9S+IldWoNyQlFqhoGqQ2ubsqvysLTCsgmhoyYw4iRo7zzCwOULVoFeFuKu3E
	60HSnVmkijiLe16Zq6bR3A7ya/1XFw0W8UA/5G3eWuELxoyFcLCTJNeThI8ME+Okr3YNX2vrY83
	iCX17J0BCcnozudP1Z0w7ntEiTKmD405B+mLK3SfsKSIB+Mf1vLsTfQwnOsAA==
X-Google-Smtp-Source: AGHT+IE+bObw4cnHorC4H/DZaOiXaL4jwhNIxZtc+NxnOZyOf8Jak9oC2PABd61aQHXIMMhBapJ65w==
X-Received: by 2002:a05:6000:1a8c:b0:382:6f3:a20f with SMTP id ffacd0b85a97d-38a872f6f9amr7723062f8f.11.1736495274637;
        Thu, 09 Jan 2025 23:47:54 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2da66e6sm78802785e9.4.2025.01.09.23.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 23:47:54 -0800 (PST)
Date: Fri, 10 Jan 2025 10:47:49 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: apopple@nvidia.com
Cc: nvdimm@lists.linux.dev
Subject: [bug report] fs/dax: properly refcount fs dax pages
Message-ID: <9b202396-cc89-4065-800b-48207c6499ec@kili.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Alistair Popple,

The patch 9c4409f51aa3: "fs/dax: properly refcount fs dax pages" from
Jan 7, 2025, leads to the following Smatch static checker warning:

	fs/dax.c:987 dax_break_mapping_uninterruptible()
	warn: duplicate check 'page' (previous on line 981)

fs/dax.c
    977 
    978         do {
    979                 page = dax_layout_busy_page_range(inode->i_mapping, 0,
    980                                                 LLONG_MAX);
    981                 if (!page)
    982                         break;

This loop will only break when page is NULL.

    983 
    984                 wait_page_idle_uninterruptible(page, cb, inode);
    985         } while (true);
    986 
--> 987         if (!page)
                    ^^^^^
No need to check.

    988                 dax_delete_mapping_range(inode->i_mapping, 0, LLONG_MAX);
    989 }

regards,
dan carpenter
