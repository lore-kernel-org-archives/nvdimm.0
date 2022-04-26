Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B0F7B
	for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 05:01:41 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id i24so16886550pfa.7
        for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 22:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mkPRDXMojyzY4qLqBJMMJM+l3Q8ZwwRnxZtf0mTrZFA=;
        b=aQPVZqzGp2TnCvBtslKJlyZIttR8ls8LDP9YYSF1m4fZ0pDc0bjVbIpmjp9rP+AZdn
         U9iIGHdJKSUOoooVz5SIoCq+zUJubJbs87F+LOckuSXH2p+0MqKSUnQUkOgz7LeXobKH
         t+2atMqnQMOuBnrccMg6G4LfbFwjBGZtr/WV7KujcJMqb5RTUfAb/gGyp6hofmOeHs6l
         /HLIxmmQtX3Qa6bi67eXdp3qIVlFieMeE5itTr5u+xhRy5p2+EqhVBfa2AfvqPO7KIod
         NwfH7Bt8ekZq3iR5QYId61qf3CDkgt6FF5MZCwQ92Nvqpl38F0yFZiCc7tyqFzcptexH
         xtFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mkPRDXMojyzY4qLqBJMMJM+l3Q8ZwwRnxZtf0mTrZFA=;
        b=foK4C2AAUOYnPnGZX2d2MJzg+1VpDUmy0SFIVkZ26lM3v8ccSTmrpPK/b1NahKg/5k
         9IXeS8DPnevi8WQceu2KSuDM0VaEjuSzgYaWlfcGf84qkNjLwgnIeVmBXe0BKLjkmSkj
         GyXaqsKEftC1hY7GxwKt10S/4BdAuiffliI6in0Xttuua9wawFqqi1O9iCcvAO0OrUWl
         lQiepDGD3RMcble/J8Pfv7R01WWYp2LG4M2Bw0/OJjk/uFM/PpuMoAwi4R+ZDIPEWzth
         PBUeGwbwPCNpvMVKroTrKvtkzYd6XgztB8eSLr2YLQh7BU41PFWvmO8qjeCRh8/ZkVf/
         G5bQ==
X-Gm-Message-State: AOAM5337Cv5X+usm4BNyxtnALfDS3YmwIhHHQCQl52oWQ4zmcozRjz5v
	RyCE6mSRpi8r/A7moUdRUHesh83xdHksbQg8zQ/qKQ==
X-Google-Smtp-Source: ABdhPJxzYXrzCZ2t/STABZZMXYFwavHW+XUOVpecyOzAXPgcgzH8fq3S7Pz9jPtglltjQh3lmGqj4iOm/BVUYT02Zoc=
X-Received: by 2002:a05:6a00:e14:b0:4fe:3cdb:23f with SMTP id
 bq20-20020a056a000e1400b004fe3cdb023fmr22462013pfb.86.1650949301268; Mon, 25
 Apr 2022 22:01:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220424062655.3221152-1-ran.jianping@zte.com.cn>
In-Reply-To: <20220424062655.3221152-1-ran.jianping@zte.com.cn>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Apr 2022 22:01:30 -0700
Message-ID: <CAPcyv4gKMM4A4MPo=xm0SP6E_7C-897K6Nfh7_wmdgY7c0gxdw@mail.gmail.com>
Subject: Re: [PATCH] tools/testing/nvdimm: remove unneeded flush_workqueue
To: cgel.zte@gmail.com
Cc: Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, ran.jianping@zte.com.cn, 
	Jane Chu <jane.chu@oracle.com>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Zeal Robot <zealci@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"

On Sat, Apr 23, 2022 at 11:27 PM <cgel.zte@gmail.com> wrote:
>
> From: ran jianping <ran.jianping@zte.com.cn>
>
> All work currently pending will be done first by calling destroy_workqueue,
> so there is no need to flush it explicitly.
>

Looks good, applied.
