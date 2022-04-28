Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5F91361
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 16:14:41 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id j8so4769602pll.11
        for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 09:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kjouH/9OcDfjAaNL9Z+THwpDAYNvExodgRiuck/rw+c=;
        b=ROtsYZT0HRf0rnydKbVjAZ+P+G4Qj24SOfZQBEB6NuP4k4UyuKiYxck0JVzcg+Hyga
         SLl7TXNIiQCITdUzfAwCjO+wvbe/BmzACIIeTLVDh87C8TES8CstbTrgVe5t93ZUFnxv
         lbPdo/PyGkwn4VG1fRfrdKMJvo5yjQiqIpPQHV6XuQJRwfgwM4Qf6ynyS9XLiE2Bg42K
         STAQW33AYnIeBK/LkapS/fN9yI4lLPbpYF+WJL/Hb93y5uxo6G0Vgtwi3oVdfbCdobLj
         R+Xzm6GBsBFDoBv3K9MiTGEMDBN6KerXNfC570z256ec0xnLl5Yq86rwwh/z7OAolIA3
         ODgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kjouH/9OcDfjAaNL9Z+THwpDAYNvExodgRiuck/rw+c=;
        b=dbdLNZQILSti54C855zoaOvi7JOjnhA3Dr0LfThZgquAIC0uxR40mjvGD6B8zapa7+
         cWLqMBOciK/SSthcCxk3UQmdv4+bi9A/kdEtF+ubMUYpPYqm/2v57nMaUX8eRHlInCFd
         tUjRwhkJzvE3a7NAIhJRYF4PG4KR/2aIMv/Cp0lX24ph0cydbd9USFMzjNXCrAlzsyG2
         tsfrr57pbFyo9TxbNatHc6JBr1RtFMdnL4RPoR5geVNntgYDmCnbgSNwd6ZTMAXfIuWP
         FivV7ndgeAodkqIe4VzyMR91uOodCFne24MibIy9WbMkFD+RVvlB4CZHqLh2KLvoGwN3
         IEPA==
X-Gm-Message-State: AOAM530rebKUWbJ1GOPcQwQXvnE2qsiscFxhT6cgYwWnhKGrj3hrMx1i
	JYO8OH5IppqAbexkex2dOGzYWnEoQAnQv+HxPU1BaQ==
X-Google-Smtp-Source: ABdhPJwqB5AP4cH43WMWtOFkq7kNAe/PuVAQkIuyDOpByvN+R45fJuNdwaPNg+WgcUbQSAKAc7xtEgSCtu3A0kQsu+M=
X-Received: by 2002:a17:90b:4b01:b0:1d2:abf5:c83f with SMTP id
 lx1-20020a17090b4b0100b001d2abf5c83fmr38905526pjb.93.1651162480588; Thu, 28
 Apr 2022 09:14:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <PH0PR18MB50713BB676BBFCBAD8C1C05BA9FB9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4hGWAHBth+yF4DoEuyZN-O3-Tsfy4BU9PCyoTwaY-kKWw@mail.gmail.com>
 <PH0PR18MB50716D0F3A25CD25F8ED463BA9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4hnj8zeLqZWXRkhVUovFKR-sj5X=P5WM=vwXxjc7qL64w@mail.gmail.com>
 <PH0PR18MB507124A7660C21A147B30AE1A9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4gtnFQd46BH=Ng=3sL-yn9ctXrjwtThCFQ-AAo9DeO93A@mail.gmail.com> <PH0PR18MB507118DFC0FDE330EA68C677A9FD9@PH0PR18MB5071.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB507118DFC0FDE330EA68C677A9FD9@PH0PR18MB5071.namprd18.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Apr 2022 09:14:29 -0700
Message-ID: <CAPcyv4j780JYp-uxQurSHj0oen=VT=pgX6fo1WzPdBYk_+7vog@mail.gmail.com>
Subject: Re: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
To: An Sarpal <ansrk2001@hotmail.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 28, 2022 at 7:55 AM An Sarpal <ansrk2001@hotmail.com> wrote:
>
> Dan, thank you for the reply.
>
> I am curious how PCIe attached PMEM (Intel Optane memory attached to a PCIe 4.0 device) such as https://www.smartm.com/product/advanced-memory/AIC would be supported in the Linux kernel.
> Do you know if there is native support in the Linux kernel for this type of device?.

I am not aware of native support for this device in the Linux kernel.
