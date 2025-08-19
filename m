Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B201258EC8
	for <nvdimm@lists.linux.dev>; Tue, 19 Aug 2025 15:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755616082; cv=none; b=YFHblkh24PCnrNL7cvWVhNN+M9iAJAS+EMPdjXi+wfoBr15ryEhAHAPRw4O/PAgPPsm63RqG+AQzbx3v1664L8A7JQSmb2dWqBy5GCmsVhQJn9ANYtO32gNqImiQBReXjOGpCN+ubpEAQXLaBr/fg7SeyUOAwmLtm9HGwbGPbYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755616082; c=relaxed/simple;
	bh=Kw6mh9YuT5iuXBLlhcDmOzk90NlzwVRMOg7fERVEm2o=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=hPOFNerr5h0sGK/CeupJIdki1NsYpz/NDjPWL/BEaYuBT4re6ZUdO5Kd87QbZV6PqTcxslNZS6uqc6WhrKAx4KmBoDSW1lbdF7glxhEl9sZji6LAtGaJfWy7R/Mrb28d1WUWvKGM4d1Oqxz2bJo+u6v4oWlRP/G/QVJiWqEptnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=XiQUNEg3; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="XiQUNEg3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1755616065; x=1756220865; i=markus.elfring@web.de;
	bh=Kw6mh9YuT5iuXBLlhcDmOzk90NlzwVRMOg7fERVEm2o=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=XiQUNEg3v8xt816mNeBJf3jWYJ+B3eYDOMpcHbmXtyVpqUsrWbL9EbrMQjY4nRuu
	 t6A2u8PUik8J2N/oZEpFEFXy0eVRMAaNSJsbT3F3hwg0YH9ZyWTRjHAKmr5/E7tmp
	 HtZoJfGshJV2VMLqWZH7i4ckxttA7k0cu6nBSZuWzwE+gYW8z2dGDBa8zwJqSEhYz
	 U7gKGIJ8+DQ2KikgER2OxlMjSvruzM26aKv8fcNU57B7SLDF7K8SABBVTYqjvtcRr
	 buJo0PHNy1P85lMCRvwfY2qSVFNzyV5lAjWaTPTDMS497k9K8mnl3Rc7IvuQJ3q5g
	 X6FydgHlM4B7noOEPg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.248]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M43GO-1uoNw90jYG-006o9j; Tue, 19
 Aug 2025 17:07:45 +0200
Message-ID: <de1623da-56b4-4b53-955c-cfed0b1aa241@web.de>
Date: Tue, 19 Aug 2025 17:07:34 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Liao Yuanhong <liaoyuanhong@vivo.com>, nvdimm@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
References: <20250819135554.339511-1-liaoyuanhong@vivo.com>
Subject: Re: [PATCH] nvdimm/pfn_dev: Remove redundant semicolons
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250819135554.339511-1-liaoyuanhong@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:aI+5eL8ZUJeBMhyqYR9LbpO6Kj8/TAcoSZzUv2SGIUWAI5Yxz5N
 Lg6ZDGuvikNBuF3lF6Tuytdq2ApWEK02sGBJJKCO8wrTj1/r+Qo/XE8Oma7cy/1+eLULUN0
 YFXbvdaD9A155J+lKJ74GtNzrSGS9rxN27Cn+5i3HcMQd/ULRkZt1OD6cIz0aSLEl03/DFD
 3jFNjE7/13q+OUTpUG60w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:p928JqyEv5Q=;pu56BkKKu0SYEbnDm2nrhYSL86b
 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
 3guQP2e61bS56JsLx/FIMROsYpzPUExNCJVi8

> Remove unnecessary semicolons.

You propose to omit only a single character behind a comment,
don't you?

Regards,
Markus
