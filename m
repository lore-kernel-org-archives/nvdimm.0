Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9D8921959CB2
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jul 2019 14:41:06 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id m206so49055802oib.12
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jul 2019 14:38:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190730113708.14660-1-pagupta@redhat.com>
 <2030283543.5419072.1564486701158.JavaMail.zimbra@redhat.com>
 <20190730190737.GA14873@redhat.com>
In-Reply-To: <20190730190737.GA14873@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Jul 2019 14:38:24 -0700
Message-ID: <CAPcyv4i10K3QdSwa3EF9t8pS-QrB9YcBEMy49N1PnYQzCkBJCw@mail.gmail.com>
Subject: Re: dm: fix dax_dev NULL dereference
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 30, 2019 at 12:07 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> I staged the fix (which I tweaked) here:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.3&id=95b9ebb78c4c733f8912a195fbd0bc19960e726e

Thanks for picking this up Mike, but I'd prefer to just teach
dax_synchronous() to return false if the passed in dax_dev is NULL.
Thoughts?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
