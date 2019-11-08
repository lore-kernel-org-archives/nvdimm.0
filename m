Return-Path: <SRS0=1yzT=ZA=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0C6FC6194
	for <linux-nvdimm@archiver.kernel.org>; Fri,  8 Nov 2019 04:27:04 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8DF2A21D7F
	for <linux-nvdimm@archiver.kernel.org>; Fri,  8 Nov 2019 04:27:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c/rQqyN/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DF2A21D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D3499100EA625;
	Thu,  7 Nov 2019 20:29:25 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::430; helo=mail-pf1-x430.google.com; envelope-from=wkyo.choe@gmail.com; receiver=<UNKNOWN> 
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 96435100EEB95
	for <linux-nvdimm@lists.01.org>; Thu,  7 Nov 2019 20:29:23 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id q26so3789045pfn.11
        for <linux-nvdimm@lists.01.org>; Thu, 07 Nov 2019 20:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tyMVv16J7OCslpOoR5c4iVdcJ28OFKyLHyBYXfuikGA=;
        b=c/rQqyN/gctVlESHX84EWbPSYYdnIV0tJ6sIPc2/8oYgN4jKBcPZCLeCwsMUXTsQp+
         +XHmX3o2FJmIYGvojLbe185mV5FqgJ5KJALkfQxGbMOM/lW8GNKNz8+rcMYFID3Y5OlS
         OyP1GahtmUvfCpxrfR6ZZ+gXQIg2lmW9xJRKyABs+2TvL0KLqHE30ygpVN5l2Hj60qMK
         3llg4q5ztIX7PdM7iFdRebvkXxmyZU3W/DbmwYdvn3eGCRzJNbvrgyz3j7TGq1gKrSjl
         zy3CeTPmXNArbCxa3v2zeaADiKEvlmGRD0YW0ZUmoseFredXjG1BUIdZ52V90tEJ3m/U
         i9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tyMVv16J7OCslpOoR5c4iVdcJ28OFKyLHyBYXfuikGA=;
        b=QahPIgUP+yQzYgV3UobrldZdR9eHUOutJ58PJ81SEwfb8LgftyRDPiIUTuxO7g0oos
         o/kk8RD34K9+YZ/DVPOPzKLpASMZ3yR18TnucHgvEp84V/b6E0LXL+LhzauJvYZ9Ucp5
         pDW2GVuPZRmw7ELsrqMY0GBrZUBforI4xTPlv0epmSWgbPH00gOww3EW/tuDm2eiurBV
         TTmNrkZ1909lYXfM3h3Z2eyL24s4gGf3PimYdwhaKIEd38R+oagGQcTmJ146fDKbUkZR
         +1u8aoOVCOeyHYtNVbLOsjvbEkQMJpWSaxRaNesWXpKZPcXyFr3exos0ZcwN44xbTHR7
         DSIQ==
X-Gm-Message-State: APjAAAXtazSNDyHD69kgE1OA9iOllAV7yRIAjhF9Qjc36ddoBuqKKlGY
	wyKTB45EiwpR0BBbrT1OeY4=
X-Google-Smtp-Source: APXvYqwo/k50XXnKj8hxh/SVe5O2eizQHcLnmh7kCKkUr/upborP9chvzJ7nv9EX/OLRcXuyg3vx0w==
X-Received: by 2002:a62:7796:: with SMTP id s144mr8753754pfc.37.1573187221491;
        Thu, 07 Nov 2019 20:27:01 -0800 (PST)
Received: from swarm07 ([210.107.197.31])
        by smtp.gmail.com with ESMTPSA id b21sm4349675pfd.74.2019.11.07.20.26.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Nov 2019 20:27:00 -0800 (PST)
Date: Fri, 8 Nov 2019 13:26:57 +0900
From: Won-Kyo Choe <wkyo.choe@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [QUESTION] Error on initializing dax by using different struct
 page size
Message-ID: <20191108042656.GA4175@swarm07>
References: <20191107152952.GA2053@swarm07>
 <CAPcyv4j-rSy-T5Qv6GbcDcmUerhQQYsMKbUY7EaGHz-GecKDtQ@mail.gmail.com>
 <20191107190018.GB1912@swarm07>
 <CAPcyv4hNYZvXP+Cg+sHtes6qisrkxoMAf=oi0x3NqOHxWNG53w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hNYZvXP+Cg+sHtes6qisrkxoMAf=oi0x3NqOHxWNG53w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Message-ID-Hash: 4CGY3CZL27L3RKNC2FHS2OPPMJOBF2HH
X-Message-ID-Hash: 4CGY3CZL27L3RKNC2FHS2OPPMJOBF2HH
X-MailFrom: wkyo.choe@gmail.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4CGY3CZL27L3RKNC2FHS2OPPMJOBF2HH/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks for the information. This is actually what I've been looking for!

Regards,
Won-Kyo
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
