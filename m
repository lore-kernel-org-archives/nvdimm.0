Return-Path: <SRS0=QYwB=5L=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DC7C43331
	for <linux-nvdimm@archiver.kernel.org>; Thu, 26 Mar 2020 18:45:36 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7294E20722
	for <linux-nvdimm@archiver.kernel.org>; Thu, 26 Mar 2020 18:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="BJz2Gxt3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7294E20722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3EB2310FC3BA7;
	Thu, 26 Mar 2020 11:46:26 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::542; helo=mail-ed1-x542.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1575310FC3613
	for <linux-nvdimm@lists.01.org>; Thu, 26 Mar 2020 11:46:23 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id z65so8172595ede.0
        for <linux-nvdimm@lists.01.org>; Thu, 26 Mar 2020 11:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8CKeQFJdTz1Qq/naY9BH32o+CE+CaDPCOGZSE/1M/TA=;
        b=BJz2Gxt3HCvX9ImBoS+jGf/1OrCicDYvLoR6Zqbgq/ak6u1O7LV9dQ6H4mZlXPOE20
         hDGZ7E+nU58m0GinuVwVlLwwfL331ss8dmHnA9HLrKG3u0uxs+3t9AON738K3BNkBPmY
         pra54HESdXMPY505pic5uy3gSUfFIZqPFpWGbEY932HgbvditkJR8XPZEXCXIPRruv8L
         ZBMsAxJfEt8tmvsk7jhgQLcp3ficYhe6oDXxXXP2i7GdjJwn/kc3CVFqo5sfeQ12u7qq
         aN31HNjaJ5Z5eN5ep6ft/x+Lx9oYFfU33JNZlepinqSjEM8ew8UlKVQi+8CoL2VwR7So
         8OjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8CKeQFJdTz1Qq/naY9BH32o+CE+CaDPCOGZSE/1M/TA=;
        b=h3OiOEAmKbvefaNycpEG0pwkloX9Q8xNHEhtKoHCf2Tzf/PhHLZnra/kdAa57jkuCT
         n0a0CZGsB2OWsW1AjKgux9xKIWhOewEd3h25FpAD0AZTWF8dCbUud388lBtWZoWgc1G4
         9PbPM6+NaYje4v3C4MsCISwYvLN46P0yORfFTo7ckqjiAPKhTUxwDh/EcfarR+6R1M8L
         D3WFY8LT2TE4Nu/mJcJakDb0Y5pKlThoUi2iME4asCq3cAzmIKKuL3vL5VbwXL73VWe7
         LcLS4Ee/WrjUkSY7MZ1PJ5uRywSG1ITMAI24+dm1S7uS8e6T4cXw8dhXkucZeZCKqSjC
         eylQ==
X-Gm-Message-State: ANhLgQ3DfNT3A+9gOW8koLlQNcq565W/35QIKafc78sGw7BMQcknHlpk
	dZDtrihp/9LQqv4z4qLP3/asDxWzzjogTg9UVzUw4Q==
X-Google-Smtp-Source: ADFU+vtf9kIKsKNUoMAkd9o/zsxkAgWcPFbrzRlLhUkgJj8uysnE4z7gYcgwZ1KNw8UToT/89V5vYafVY1fAdVl3tu4=
X-Received: by 2002:aa7:c609:: with SMTP id h9mr9355697edq.93.1585248331053;
 Thu, 26 Mar 2020 11:45:31 -0700 (PDT)
MIME-Version: 1.0
References: <BN7PR11MB28495CCA929E46ADEB9B6B9296CF0@BN7PR11MB2849.namprd11.prod.outlook.com>
In-Reply-To: <BN7PR11MB28495CCA929E46ADEB9B6B9296CF0@BN7PR11MB2849.namprd11.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Mar 2020 11:45:19 -0700
Message-ID: <CAPcyv4h+uYSO3nYnOSOW-g=T_+puv6XzxvuN-GBca5Lua6jSdw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl/README: Add a missing config setting
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Message-ID-Hash: RNGPFZKVATZQAGO6QHUTJMFHQE4IUZXC
X-Message-ID-Hash: RNGPFZKVATZQAGO6QHUTJMFHQE4IUZXC
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/RNGPFZKVATZQAGO6QHUTJMFHQE4IUZXC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 26, 2020 at 2:25 AM Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
>
> Add a missing config setting to README.md:
> CONFIG_DEV_DAX_PMEM_COMPAT=m

It's not required anymore as of:

https://github.com/pmem/ndctl/commit/b7991dbc22f31d03a38f3ee2dca4446fb55279e3
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
