Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEBF433B3
	for <nvdimm@lists.linux.dev>; Fri, 10 Jan 2025 06:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736491076; cv=none; b=tZDUXXjEhs/+xuV3tYKp9hUWmiRw3ZWUcFEUgrVT9xubFW/VB2vVbR1t0BJRXkasJfO+46Bh9V7FxlkmrCWIbDWRMDKN4jmdNjJo/ZwBKwfBVE5tbXj6NmftDHLDYO/h1dpGBDlJd4B6g0cZgzl5OYkR1hc7AetyTLJLaztxpjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736491076; c=relaxed/simple;
	bh=awsTPmQvBlkJV4QItLFObuZLWLIeKMzAcIxcpxE5PEU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DdjoXicmFEBy3uYR+Nu7awGmyAmogcD9oCuKjVVWRwltwAyn5P+ynpikTV2g810X7czRi4lSNXZpQCc81E4/ADx1NNmsYVqena82P9NSA+r8ECBJtr/UsQYrXWqSIJu2MCpLlbiI7hLXssiLR32lKA2vkN5Gk36zH7i4worBHcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uGom46B0; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uGom46B0"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-38a8b17d7a7so897340f8f.2
        for <nvdimm@lists.linux.dev>; Thu, 09 Jan 2025 22:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736491073; x=1737095873; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JFYR7aJE4K0RLJJn1Yc12u/2E+HvILbr6XuyBiLmQCs=;
        b=uGom46B0HEft78f3J6FFgzSi6SE81+1rZ4/ljB/gD4bCe1Zgs066WxNz6KwCexaNDU
         IKh+8WQSExwqfdpiRNl5juXA8mRzmhKJ7nLcG+fBCgl0cuiJ6Fcg4io4wH5BNGDJ+sr/
         fWrxSlpqJ2Ms8rjb9khiBswQXLsxV5h4XPj+/60mlKUTq03OnVp7ukHssLk4D8DE56ZN
         s2ZadJKqww0Q9SqqmkYz5phzT33a0l4tLqCFqyItlaidOFHjGTBEOLSwUnOMrBzaHosb
         +FWcGnciCuXkE1ltXdcXojByiioq9bjQyPmF1HOH5JHIwy+ek1T7E5GoF3CdTeTFg63d
         oNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736491073; x=1737095873;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JFYR7aJE4K0RLJJn1Yc12u/2E+HvILbr6XuyBiLmQCs=;
        b=C5xCEcMPs2H6RGQMzbWHVjkyptbRkKCf64BLIEUihLb4tNDGvnsVvezURjw3HY+8c5
         5MuMCcR656FYFizzSJKptUWh39+487NDGgL2okOnNTE6WD67cDGBhHLm2TsBmRpY+508
         /4VCHmx/jfbQr/5JmAxcoYkxOfniJT5Zd5pb3Tppcgpx3eKrl9OSoJ10/npCu5DxE/Jx
         UT85H+WzG8tT4K9HtCpwJhzrey2musXG8aZeN6YcyLWPwEoX7wINn3MGYjha+vr64jdW
         RssYvqpl8uf0tIZ5wHZBUunNeKXPdZayEYmkgpUY+lLlkwW4cM0qpwW462FCJNSbFWSd
         T9Ew==
X-Gm-Message-State: AOJu0Yzxia00BQMm4gDWw2Jxn86YkU6rYLMEebl9NpP4iDiSVeDRhKh3
	ONVlByIyvE7jpdZF7g07aNrxmZdbqYOxchMmRE31zEErhZYO2Fyk23+AUU0jWbY=
X-Gm-Gg: ASbGncvqH5E5mt4s2hp4lvoiewyiict92GG0RF3qR1NNcrxs1ysJZz425ycLxE+fwDu
	hpoxMrjYluZaAKd2vKzWtU+kIYIp5fUU6yYiumWGuhbtqqOpbTvFulzXnX5K0GBp3SHQeZ468dq
	rNvwEsaiORTjy62lr3O8FdHwnvl0HL4BKVQbFxg0AbdHS2oFkntxn8x15+JFEML/gKv6iqDs0tO
	XmKX625KTM/9ET+P5mO6luv6GwhE4OkoBu1V53nXs+7k659Nh3WpB8PsFGWhw==
X-Google-Smtp-Source: AGHT+IG1Dx6WEsIq4Wrt3DN0FdjnHx5JsV++TFvOm7TiHBJqkEKo9M0c+WCGQf0nzS65xPuKuAYtVA==
X-Received: by 2002:a5d:5f52:0:b0:38a:8647:3dac with SMTP id ffacd0b85a97d-38a8731fac1mr7651934f8f.34.1736491072662;
        Thu, 09 Jan 2025 22:37:52 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e383965sm3716240f8f.31.2025.01.09.22.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 22:37:52 -0800 (PST)
Date: Fri, 10 Jan 2025 09:37:48 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: nvdimm@lists.linux.dev
Subject: [bug report] fs/dax: create a common implementation to break DAX
 layouts
Message-ID: <92b31d7c-3a51-4cc4-a679-ddf271fa8521@stanley.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Alistair Popple,

Commit 738ec092051b ("fs/dax: create a common implementation to break
DAX layouts") from Jan 7, 2025 (linux-next), leads to the following
Smatch static checker warning:

	fs/dax.c:966 dax_break_mapping()
	error: uninitialized symbol 'error'.

fs/dax.c
   946  int dax_break_mapping(struct inode *inode, loff_t start, loff_t end,
   947                  void (cb)(struct inode *))
   948  {
   949          struct page *page;
   950          int error;
   951  
   952          if (!dax_mapping(inode->i_mapping))
   953                  return 0;
   954  
   955          do {
   956                  page = dax_layout_busy_page_range(inode->i_mapping, start, end);
   957                  if (!page)

error is uninitialized if dax_layout_busy_page_range() returns NULL on
first iteration.

   958                          break;
   959  
   960                  error = wait_page_idle(page, cb, inode);
   961          } while (error == 0);
   962  
   963          if (!page)
   964                  dax_delete_mapping_range(inode->i_mapping, start, end);
   965  
   966          return error;
   967  }


regards,
dan carpenter
