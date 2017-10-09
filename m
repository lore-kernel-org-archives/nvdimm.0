Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8DEB62095B07E
 for <linux-nvdimm@lists.01.org>; Mon,  9 Oct 2017 08:42:15 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id j126so40493006oia.10
 for <linux-nvdimm@lists.01.org>; Mon, 09 Oct 2017 08:45:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171009080745.zxckckm4xdtx4i7j@linux-x5ow.site>
References: <150738928223.25087.18137727671163532987.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009080745.zxckckm4xdtx4i7j@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 9 Oct 2017 08:45:41 -0700
Message-ID: <CAPcyv4hPA=hvQS8KJcihEEx-yVeJwPMPUBVe1oRw=tXeO-Kerw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, test: rdma vs dax
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 9, 2017 at 1:07 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Sat, Oct 07, 2017 at 08:14:42AM -0700, Dan Williams wrote:
> [...]
>
>> +rxe_cfg stop
>> +rxe_cfg start
>> +if ! rxe_cfg status | grep -n rxe0; then
>> +     rxe_cfg add eth0
>> +fi
>
> Can we maybe skip the dependency on rxe_cfg? All that is needed is modprobe
> and echo.

Sure, I'll take a look.

> Also hard coding eth0 might be problematic in this case. This works
> on your test-setup but surely isn't portable.

Yes,  which is part of the reason I have this listed under the
"destructive" tests. Any advice on how to make it portable would be
appreciated.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
