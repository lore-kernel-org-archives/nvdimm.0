Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720576;
	b=oMvJ+zBdje0Qi9/oSkqSd72EZVVm7csLnlVVyo4tat84Lfszj6U4bbxE36uQrVfbj0cy
	 3E53dXmpLxHm9FQqKFVa8e6u1BJ4fWo0F0EPwLlMV8B8qs4Y1BJV9PKdIAWInjKc5FTXF
	 c58wyFyYB39DzT9FfQvc1uQz0ouBZSL4gUjAz8AtjiXECAZsM2hBzYyK8DnvAyjGSv0N1
	 mXJ1i8IFKIXXs+aoOekrqKgcl6toCdbKk37Jkw8VZGOZjVEZQj5GX016MUTacHb6XV+8d
	 i9pe+n8pzDjBANqxpa2M01h/84Khl1MO8xzZlggwardehbJt7uY1SmgXtH+qMb7gEnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720576;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=qSBKQkoV/2gEOYXQ7dyktjSocPAeCSzJyj2oztarUE4=;
	b=lf5Z0d8OxEmiDu3KxN+LrJ3F18XNMyGM2uzAoyp/9SJT6ODcoRy1Emrq4KMeGdffhWOr
	 XIaYvYe/tmun3Wnh85Fpv85lUwwzDjfWIHlsw9EcNST8hiSFA1auqu1Sykq3Hi0iuQHtr
	 lhRrbxefp3G0mk9gHBYlhl4d8JGVqfZIpvfhFZWdxr0EXVp0YZKQtBfQzT7d++ml29yjQ
	 wCN37b7fGBE6+o2utygVKNVJrUOIanTCH6IFn9LtJDUE5CwavAuuYv0Zu8NT4PF0bm2uM
	 Fn07jpLp45IhtiJ8eNgUbP6Hq2jrrEtcmDNAPgUiu1P/s1bJXBEI0ZYXwyAwzOK01Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=glQVe4Np;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C466A606A31A
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 01:56:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C466A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=glQVe4Np
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53667180af3so3769781cf.2
        for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 18:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792720575; x=1793325375; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qSBKQkoV/2gEOYXQ7dyktjSocPAeCSzJyj2oztarUE4=;
        b=glQVe4NprWb9O+RYMj51trZJYavyrSdv4zcQS6MlQPHYkAFd1g6M3MCQix3XA6FeWy
         BBtz38ZnWLR8Ob99eeezPv2js6ZTf6VYxxLcu4e9Q6yixPCizpyw87of5vmjpTnq3uVt
         hadLwCtRoE0MVwExyI2iqmsgkaIhcfICAHJh9/Ua9lvwsIJTP2Qphcw+wzLhL7y/U/t9
         //dlUa5ajctRxcIHgSji6XJ4RQxinIXLv8HvIJXHXja471eW6/zb56sXJCdyTfP8dVzK
         zOQ3v1BQScCHBxb2gC2/cPOWgrv4Sd598eL0KQUyncdmfIbkLHWz319MxrAHD1JocoqQ
         3TSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792720575; x=1793325375;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qSBKQkoV/2gEOYXQ7dyktjSocPAeCSzJyj2oztarUE4=;
        b=fDXdKBBnYcxNo5G+M18sD3qKQGlHmSGRUtWaalRYc8Lr/BOXJrpa0AJadgxPJ75mJr
         aficTy3TE4suv1YF0cxJAGKlif1+g26ggvijWt9hAm8kp7Lu0JX70zy43Z4jW4Ax3b0c
         BiswjEhPHdFtPBu5yW35aUWz6C/cu/TYtgCjMXQfEMh1qBoYYvAOWkg8b/9Sv7obk+iD
         aeZmLSrOYVseLfZawaga7CSMwTbsuqs4egCSofMHLvw2WPVV01rgvKfD3TphAWuIxEmO
         GloiJKIQb0c5HOZzC5RYhE5Lq7Y+PlauvwjyuqAXYPPPGjvc0m5ija878aWpjgJQUq7k
         iHrA==
X-Forwarded-Encrypted: i=1; AKwUvBxeBB1NrJTakI/kwDUeaGz/jO5vOBtMJuAc2WL/Xz2FKl4eItln4WF8OUh7Rhg+qJUrb9Ht4wI=@lists.linux.dev
X-Gm-Message-State: AFq9FYIyjVopNtrl1kCbgVql/IzEes2CoCI5ZOmYatA6GisMnG24UGJR
	jxRx9Kijk/MHxhpgH1fK2+BUmlWsPKt6Pjy6PTt9e2oBkMY9OduapoKw+4ZDBnAvevk=
X-Gm-Gg: AYBFou0p8vUeZ3EumCP/iqabUE3Jkw1MImZZiq2z5D7QED+HX4tmmJym2a8WJeqvSxo
	4S5wmzV6j7n+iuwDET5eIWj67znXSDrtXa1+R7bhPdt0WUxE2qGR6qep4MRb0HqWccFGdTn9RJI
	k2esUIG8a5a0Nt/aKuTqB2zmei+RzPVQGtdp41MxwH2f+T+W98VSXg3IoyIPRK1k5sSgpIyCYev
	vwEut2DTttTj4wgyZjH9MlL5ycyEscIJyX2dDZ72nMs0CZRqWPeuHbUuuE9b1zMulF+i9p+JMfp
	BFqoKxBJLBMmM/sbuCgQMBiVyN/5FPn1RRae/mzRPpgXG6R5qTLPYx1ACe5d7eLyu1inYthSZci
	IOwMWKq25JSqPpiaWditzve0JIFsEYpgPhs9ip5jBJp5SND9XSNms34tlcc2USYekKZjnoDS+fL
	OdxosHJ23TpsZ4zLTPNwivYWT+J/kVzZ3E/TptzNQykr0GqesH3Zmnci5BRLR/B8PlUOzlBSkzv
	Bquc46o4pfspUaEbCXRfilCWWZ2mpTx4yKAYCn55kD9TketOMlyrPxZFvtKQdRLNcxa3h2WvksD
	3OK0Pd/7iwk+urAvHXAH0SQexsw=
X-Received: by 2002:a05:6214:c4d:b0:917:84c2:67ba with SMTP id 6a1803df08f44-91c3a9d6ec0mr9891546d6.34.1792720574666;
        Thu, 22 Oct 2026 18:56:14 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c396af371sm7558586d6.7.2026.10.22.18.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 18:56:14 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/6] daxctl: offline whole-device memory via atomic
 unplug when available
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org
In-Reply-To: <179272009864.802238.3707618429496053322.b4-reply@b4>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-4-gourry@gourry.net>
 <atly9gd-Rsf-AoqB@aschofie-mobl2.lan>
 <179268760050.4072493.10054383256417425305.b4-reply@b4>
 <atqHe2AK6Tka4t6f@aschofie-mobl2.lan>
 <179272009864.802238.3707618429496053322.b4-reply@b4>
Date: Thu, 22 Oct 2026 21:56:13 -0400
Message-Id: <179272057300.1197960.3345278232450834067.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-22 21:48 -0400, Gregory Price (Meta) wrote:
> The intent here was to try to get drivers creating dax/kmem to actively
> set a default and effectively deprecate the global hotplug auto-online
> setting (because a single auto-online setting for all devices does not
> make much sense).
> 

there may be a path here to allow offline->online to keep userland
clean, let me propose something before i iterate this series further.

-- 
~Gregory

