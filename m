Return-Path: <SRS0=iZWN=XH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099B6C4CEC5
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 13:31:58 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B549A20830
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 13:31:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B549A20830
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A3BBF202E2927;
	Thu, 12 Sep 2019 06:31:59 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=209.85.214.196; helo=mail-pl1-f196.google.com;
 envelope-from=bart.vanassche@gmail.com; receiver=linux-nvdimm@lists.01.org 
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com
 [209.85.214.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D3A5D2020F948
 for <linux-nvdimm@lists.01.org>; Thu, 12 Sep 2019 06:31:57 -0700 (PDT)
Received: by mail-pl1-f196.google.com with SMTP id k1so11803259pls.11
 for <linux-nvdimm@lists.01.org>; Thu, 12 Sep 2019 06:31:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=YbzzOwLPVFiyZazgwx4oK1haet1LCDg9IL0AWwLCITc=;
 b=RuiWEM/sCwjxkcnaLqEbXCn8KKYUtDL3KBOmH6LpnPuJMzdRUE91L+TsJaw+7FsaBM
 KWi3qxGgY4z+Iu59YACD4QFg10+1aFw2kSQJzPz+QtzqB0fsFa1x2BReKsMLaFeKfEIQ
 yAnunM3Gx60YCqJa6Sfsn0CjydGj3DJsJV8A2xCYEwaGObfgu39VhA8LWSWpuR3sIhWe
 S8z+jENMvv0O7Th81Yc3xrp7dXawVkR6iai+vrq6Dub0kzmcm7glW5dKc2WWULjA+2p4
 W9Ox6bBMqEzbRIehE+gpv3iYePsQmeKFpl/b0kIG0G/K30buKGanV8eNOFxxHR8M4YXd
 /rTA==
X-Gm-Message-State: APjAAAVzs7OVuVIPj9s5iKXljZ77H0N1yMUFHraXQWt5vyHN60FD5//f
 JI0pVQABjQ1cXCSuH2KP0JI=
X-Google-Smtp-Source: APXvYqyA9LmsIt46UYXRB/qnJg8y7VckXgkY1MT7b0npn/YciW4Pp1oR+XE+tg5ecGsQCpqqGjw73Q==
X-Received: by 2002:a17:902:b710:: with SMTP id
 d16mr12261985pls.55.1568295115090; 
 Thu, 12 Sep 2019 06:31:55 -0700 (PDT)
Received: from [172.19.249.100] ([38.98.37.138])
 by smtp.gmail.com with ESMTPSA id c125sm31524292pfa.107.2019.09.12.06.31.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 12 Sep 2019 06:31:54 -0700 (PDT)
Subject: Re: [Ksummit-discuss] [PATCH v2 0/3] Maintainer Entry Profiles
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Dan Williams <dan.j.williams@intel.com>
References: <156821692280.2951081.18036584954940423225.stgit@dwillia2-desk3.amr.corp.intel.com>
 <yq1o8zqeqhb.fsf@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <6fe45562-9493-25cf-afdb-6c0e702a49b4@acm.org>
Date: Thu, 12 Sep 2019 14:31:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <yq1o8zqeqhb.fsf@oracle.com>
Content-Language: en-US
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: ksummit-discuss@lists.linuxfoundation.org, linux-nvdimm@lists.01.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 Dmitry Vyukov <dvyukov@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>,
 Steve French <stfrench@microsoft.com>, "Tobin C. Harding" <me@tobin.cc>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On 9/11/19 5:40 PM, Martin K. Petersen wrote:
> * Do not use custom To: and Cc: for individual patches. We want to see the
>   whole series, even patches that potentially need to go through a different
>   subsystem tree.

Hi Martin,

Thanks for having written this summary. This is very helpful. For the
above paragraph, should it be clarified whether that requirement applies
to mailing list e-mail addresses only or also to individual e-mail
addresses? When using git send-email it is easy to end up with different
cc-lists per patch.

> * The patch must compile without warnings (make C=1 CF="-D__CHECK_ENDIAN__")
>   and does not incur any zeroday test robot complaints.

How about adding W=1 to that make command?

How about existing drivers that trigger tons of endianness warnings,
e.g. qla2xxx? How about requiring that no new warnings are introduced?

> * The patch must have a commit message that describes, comprehensively and in
>   plain English, what the patch does.

How about making this requirement more detailed and requiring that not
only what has been changed is document but also why that change has been
made?

> * Patches which have been obsoleted by a later version will be set to
>   "Superceded" status.

Did you perhaps mean "Superseded"?

Thanks,

Bart.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
