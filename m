Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A490246783
	for <nvdimm@lists.linux.dev>; Thu,  9 Apr 2026 09:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775726904; cv=none; b=Cxa//3hxu4grj8s66cHQcZmPn/WHJU3l95lSN4dDECQJAfH1Ao46NXVAKX5JjnOCXb0BStQkDHD8VIdV3FyC4Yh/8tbsEe5JfpCM4p8mpLI94fCYOaNhfeGp6yjy2I9p6OQQGafwLXP+gNROwd+I4N5OctOM55LmbLD7W1Nbr6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775726904; c=relaxed/simple;
	bh=K2JpJFTu4zPMHGNh0ht4DTdv2jUw4nPbWQBx5nhGmS8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ts65ooAJmV1ffPB6edmMFru+z/fRHiCraWvnJRk8znviHKZtOdmpMj+Qd5oCmsaCvEZAXM89N9A59+MY7Gti8rikWG/DlFU0cCjYzequD+MaVSvekPiqDajYhGXR4SLkCw9Si6swWGELyOflAaPlqgD7MxTts3wap6zcxS6musw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s066jHbY; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s066jHbY"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43cf8d550bdso613553f8f.0
        for <nvdimm@lists.linux.dev>; Thu, 09 Apr 2026 02:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775726901; x=1776331701; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zzELohW/bUBQ0NR/GcWVWevr0Zo7GfxS5HNBO/h97QU=;
        b=s066jHbYXP1SQv1uE+qJwweiwHQ17F+7YYMNAzxrg+P4GJLvhiBrDRbYhoH2zTYAd1
         j4rw0DM0JBZRd8MJP2eIKS7btccbJCnfoYXGcxGR5jOFoBzU2pb1ZUxxXA5py9pLO4R+
         u/aIPQW3dziu+zFirfx9ZfcAhZHF7+LYTkYeDOKpdF5Q1yHVczPwkFA+yXxvU19fq2Mk
         GkuDf5qPEphqnaEhcbwo2lydAz3MzsexUpIqVuBX4K7btWTPjimbqUwhUmu3rKt8pytc
         xZLpCUXB1BOmxig9ceA39GV66h5snWoJ2Dp0QGOcTKAqJLg/IP4GMhPs7wSjKVKODAj3
         Q8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775726901; x=1776331701;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zzELohW/bUBQ0NR/GcWVWevr0Zo7GfxS5HNBO/h97QU=;
        b=W+WdibA73ZE+xN8zJjX1a5r7dZ+7EAkivaozG08B8TGqCLAqrYJLVDbu0LyDe5mcGB
         OmVuII/pC+ALhCUrYT+T8blpNhocRaEV3c3SP+IdjPZ0XDa/571W+htKUYG7QFjOqjWd
         8W0I2MuK6oRHqdBok9jwrJLl5raLwJqZeW9xuwH+ZzbOyVDYfg4IKjqPrIsjcrJCdVAq
         tOlYVFdw1maCeFm0HrDwidO0H2EX056JNdSnNCxl+ZCdETptjgs5lnUhMN0SUeAPmt6q
         jzLJ2UOTs9kPDjOFeZfTY4WZ4RqdedjSbywPcEEUMCDYoO5IJZzUcjZcqI7nge0a0eQJ
         J9Xg==
X-Gm-Message-State: AOJu0YysnqB/tfgZt0CSBmALc2XekyBd94NNevtm4hF5ijBwr6LVWgwc
	7JR+aLRM1uYnzgGvn9aNYrYSmCA1Ug/foGZRBorv63JnTV+gu7FgXNqG
X-Gm-Gg: AeBDieubZAMlTEFyWK3uoo8t4ERTY+zbjFHxQL12/yxkEdix4LUCdPDcWA+PpzowUfD
	k2IPtfVJs1xG9/ForTKZBoMD6S9hXSnGFSTqrej0ww0Ix9hzubxZzDqCmqvuj6gNRazE3+GCc6S
	M6quyRqKKJujmTeburtxP7QLuKnjA1RrU/mGaIDcN8KNY969jjCxkNU3/UiJ3mtjMxjiJ2um6Dm
	B4uXTTc2yCHWuZ8Uihe9oS++TVaBaSERqam+hRB/cc1Y3iTpkgiylQOHcbN8OvOlT3FRWKRJq29
	V8E9ZNgtEtq1cJ/wMzhYLHTkennTiDJdKFxjPOSYh1LL+sV3plnII86ApHxDOTwqlmYYmWzoRvZ
	iG+wxf2JZnlk8QTTUbOUc6jja9frnKKhK+xbbsp09qmZjsv7PKp3s6trurn0sjb6YxlpecjYY9Y
	ly97b79AjkQZqYfjfgYDms1fyIF1FKMQ==
X-Received: by 2002:a05:6000:22c4:b0:43c:f66e:f24 with SMTP id ffacd0b85a97d-43d5a17cfa4mr3528664f8f.35.1775726901268;
        Thu, 09 Apr 2026 02:28:21 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e2c50a7sm65395917f8f.15.2026.04.09.02.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 02:28:20 -0700 (PDT)
Date: Thu, 9 Apr 2026 12:28:17 +0300
From: Dan Carpenter <error27@gmail.com>
To: John Groves <John@groves.net>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: [bug report] dax: Add dax_operations for use by fs-dax on fsdev dax
Message-ID: <addxMYPgp5t3oysP@stanley.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello John Groves,

This email is a free service from the Smatch-CI project
(smatch.sf.net).

Commit 099c81a1f0ab ("dax: Add dax_operations for use by fs-dax on
fsdev dax") from Mar 27, 2026 (linux-next), leads to the following
Smatch static checker warning:

	drivers/dax/fsdev.c:86 fsdev_dax_zero_page_range()
	error: uninitialized symbol 'kaddr'.

drivers/dax/fsdev.c
    79 static int fsdev_dax_zero_page_range(struct dax_device *dax_dev,
    80                         pgoff_t pgoff, size_t nr_pages)
    81 {
    82         void *kaddr;
    83 
    84         WARN_ONCE(nr_pages > 1, "%s: nr_pages > 1\n", __func__);
    85         __fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);

The checker thinks __fsdev_dax_direct_access() can return -1.

--> 86         fsdev_write_dax(kaddr, ZERO_PAGE(0), 0, PAGE_SIZE);
                               ^^^^^
which means kaddr is uninitialized

    87         return 0;
    88 }

regards,
dan carpenter
