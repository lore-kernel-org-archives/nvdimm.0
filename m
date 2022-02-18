Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD03F4C94
	for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 21:53:35 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id u16so3344707pfg.12
        for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 13:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PZXhaWbIOXPQuT8HgBVIhKVVo55naTZ6jyJBspy9kt4=;
        b=CDiKJo+2jkhA827OSKNjg9iykVaGNhfa9oxg5fwXUWWCNQZOjLGAix7tO5YjzkL/Ss
         XMwD5IMw3t94TowotEMldgov1lqUr7dMrANeViPK8j0yxC1/vaiydq+2+98UMRxbBHbH
         fo3VqEeFUT3gyEFZXrIfl9rPjZDjZl/ITsoiPu1h8fgAep1fK3WuFDq0jsudLZM6eSZk
         M32r6xV4d3PfvU+pD5osbN2GgyZkkHunjiUp9WGAvtN//QK/o2WIkWCvm46q5zhaKm51
         Nay0QA1OOLi/CLSCOOGaeSyQzqPPgaydnbGIhQS4WjZ1JLu3MQmn3HCXr34rAVyzIH8p
         xr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PZXhaWbIOXPQuT8HgBVIhKVVo55naTZ6jyJBspy9kt4=;
        b=o33lb1bNWk07VyU2nphRNZUWilSkaJummhiZQ+kM6Ul+xnak9kgfMx38KUVvA3US8E
         qzjE0QYDW02aOxhQkn7WHkF6LeYK+zSQDfzIdxk8UJxQpCi3OIZiVrLs85ZiSE2LNG6h
         9vUg6jkTn5UbJ4vPFEqUuau4t5l9HbFcWAIyDXpxO9Jf7pTMpc+1XvC6iWu4I/Hbwvu9
         kX2+XnnquNb71RTCbmWE3zQHyM6/ePt8kb8yF3v67a0U/r9+GB7fqc/h9mdrRuZfXagi
         V0mya/uzHF1x2QZavjZ+f2yhivmvo7UaycRMm1M3VZBWcmex96j7BpgeUdj9HbF7IBrt
         V3gA==
X-Gm-Message-State: AOAM533fWIrkrIEYiDCgoRIm2beKY36FOVERRYiN00FlkB3iSXE+LBJ3
	9nQJURBr5O5fKJEy20IMDeIP5TkNXn+lGjKePrim3g==
X-Google-Smtp-Source: ABdhPJy5ssiXYUNonyfu/HjJBCdDQCLxCIw8UJpjcjS1wK2sHSvuZZeBneLbc0kOqNe87wUfmX2j7YIiihiYLa2Igmo=
X-Received: by 2002:a05:6a00:8ca:b0:4e0:2ed3:5630 with SMTP id
 s10-20020a056a0008ca00b004e02ed35630mr9561872pfu.3.1645221215341; Fri, 18 Feb
 2022 13:53:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128002707.391076-1-ben.widawsky@intel.com> <20220128002707.391076-10-ben.widawsky@intel.com>
In-Reply-To: <20220128002707.391076-10-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Feb 2022 13:53:24 -0800
Message-ID: <CAPcyv4gA+iimMxGay2ri9eceOrYr_5Hhjfomzh910rQExOtoKg@mail.gmail.com>
Subject: Re: [PATCH v3 09/14] cxl/region: Add infrastructure for decoder programming
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:27 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> There are 3 steps in handling region programming once it has been
> configured by userspace.
> 1. Sanitize the parameters against the system.
> 2. Collect decoder resources from the topology
> 3. Program decoder resources
>
> The infrastructure added here addresses #2. Two new APIs are introduced
> to allow collecting and returning decoder resources. Additionally the
> infrastructure includes two lists managed by the region driver, a staged
> list, and a commit list. The staged list contains those collected in
> step #2, and the commit list are all the decoders programmed in step #3.

I expect this patch will see significant rewrites with the ABI change
to register endpoint decoders with regions. It's otherwise redundant
to have a 'targets' array and then yet mosre linked lists to walk the
decoders associated with a region.
