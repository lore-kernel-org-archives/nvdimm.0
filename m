Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B40A8BEA
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 22:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744238941; cv=none; b=ky0Ax/5WgVoTfvLi3JsSSpcczu0TGEbr6nrMg9SaXwwRbiVx4+CVmapxvyZxNHQ9cO3nF7kFfs62DwPYdNQmeOPvlE/fOHmvGbfhku2qt9/c9h77677zr7qRkmlfztkEQkzGKKQVwKFxlLLpsBKMSWqqG25I/3QAIeyCQ8C7WA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744238941; c=relaxed/simple;
	bh=9EcjlMK/aECC7Z0EsbqajEnUDd5WSMpfa5B3tFPhdFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Es88k+4pY/as+m0FY3hhGHJ6wxJ65kt/nfwmX8fsWkSkydCBJKubYrp13DpnfnoX1l00IMnoFFf5VAt2bqXSVdLvEO5DrpNauovFhaemePSl2nfwqGVrxLKvgYOnbO1osqwxnIWhTcxi3a76SM1zn9M0NpLAHAQAy0JGErBeujo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=P4Kfyuk1; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="P4Kfyuk1"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c5c815f8efso19592785a.2
        for <nvdimm@lists.linux.dev>; Wed, 09 Apr 2025 15:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1744238938; x=1744843738; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/htfkjUcjTtbQhaXMacTvcz8vKgEhUM6n8QlQjKIc+g=;
        b=P4Kfyuk1+lppU0NjduMPyiBz6GxC5Ld7xJgzUP8AiX5WQBI2zEie4Y4M4Q9pSKYHbx
         w0Wql8UJHYPegi0pwk0ArEuuAENA/ocX61wy5y118fJffey9WdscqQrhF/MWxiffSMsi
         QBHZ/F26qUjqIVqaEV/7IKJwpQcjPp3ajAm74dW0of+umZ3D134bz/ELo47f2mgJDtdl
         ZvWQ2uxnc0dUrcmu8eyINTlSw6QZmYSsXRK+v/kr26n8JXffOdMv9sYZumIDjDC3EC3s
         zZet7pN/YkFgM6YhqXHe/pPNodWLxKG120dbo1X2vuB6qSbXUDMkxkgEV1hhzt0Irh/9
         VVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744238938; x=1744843738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/htfkjUcjTtbQhaXMacTvcz8vKgEhUM6n8QlQjKIc+g=;
        b=nf81UiQeGEKLELQ561P2wqfKruBkwIKlsV8t1putloQAXbhsUOH2i+FKxTWyu1N7gV
         wLzrtqhSs4icWqWPL25a5bTeJobVWBFEpKKOXmkYmfl08by/vuyomzAb8Boi7m8jYpbv
         uMSyFslI87d/Ed0a+DyFOZHoe+wz4ldwlPzVsssZX+rpDuaCPL9P653i1rsXY1uZ5EyZ
         8nZFzjsfuMPbyfY4Nzv2RsBcXHi5L7UCYHpOtbYs6ygjVwCIbH6bO1xz0253w8X6lMdz
         O8pxYb0BcPUxno4mycQVa0dqpJu58b0atlsAdGL5oBmtPW1rATcwf7TO3pv0jwrPJjqB
         jgjg==
X-Forwarded-Encrypted: i=1; AJvYcCW9Ecuj1Ju2sotaxYteu7WbXeOPXxrULsfGgW17JNEdRddro1tyYt/kchqjvkfPlddQMCJ1zeQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyg4zVoIK1LKRM2l2x3GUnMCC990vKHALQHh5q22PRk9Z0I9eQZ
	fgDx0E5FTPYXctNZ61VoH4SV8i5to6FklA94n9RXFuAmt0NnZTEm2NLhLBoQ67A=
X-Gm-Gg: ASbGncu5I19LYUDAQLRC/HBx5sqUtHAQt4/i63/KHV53Ev63fTB9/OSrco7+hwr2iOO
	xYsapZjb4FJEjq62CTgymYTYX+YdzMVJjHbxeugFyR9Jhx4hfmrYKDFaEtBb1/+ZcIEu6jKU45t
	t/Mo3o27nM+xyR48decS09uYcNd74tECYbF+daXr/YP741XCBA8X7gcB5nTAV6BPTvpj2qJ/+qJ
	f79ZoJ3Xcats0meSPuEpLCm6LE2CgPUa1zoy//v6XBahTcL+vGro//T3qtYAC/aozvD8pSTxUQ8
	ZKabUeSuvOeldUXxCz5j5Lz5nqE8vjGDViZ5IwQqT5K1ydmou3laWg==
X-Google-Smtp-Source: AGHT+IEKFpKNfsSWwOgoi6DRSObHn0c2ff/NBOM3pXCDlmuVPinzb7ITQcqd7tkPTc6RK5Po6EYdag==
X-Received: by 2002:a05:620a:1712:b0:7c5:dfe6:222a with SMTP id af79cd13be357-7c7a81b14fbmr21927485a.42.1744238937941;
        Wed, 09 Apr 2025 15:48:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2607:fb91:e45:4a49:ba4d:3fcc:71ac:af2a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c7a10d0ec7sm126492885a.59.2025.04.09.15.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 15:48:57 -0700 (PDT)
Date: Wed, 9 Apr 2025 18:48:54 -0400
From: Gregory Price <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <Z_b5VsY0S5cihYga@gourry-fedora-PF4VCD3F>
References: <20250402015920.819077-1-gourry@gourry.net>
 <Z_bzAapzjzFR3u_P@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_bzAapzjzFR3u_P@aschofie-mobl2.lan>

On Wed, Apr 09, 2025 at 03:21:53PM -0700, Alison Schofield wrote:
> Existing unit test 'daxctl-devices.sh' hits this case:
> [   52.547521] kmem dax3.0: DAX region truncated by 62.0 MiB due to alignment
> 
> Tested-by: Alison Schofield <alison.schofield@intel.com>
>

Thanks for testing, good to know there's an existing test for this

will respin w/ Jonathan's recommendations and tags.

~Gregory
