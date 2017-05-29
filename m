Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D127921A16EC1
 for <linux-nvdimm@lists.01.org>; Mon, 29 May 2017 16:03:02 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id b204so92057179oii.1
 for <linux-nvdimm@lists.01.org>; Mon, 29 May 2017 16:04:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c5a2a27e-50ee-b08f-4e2d-d8fbb496adfd@gmail.com>
References: <20170529155643.5848.E1E9C6FF@jp.fujitsu.com>
 <c5a2a27e-50ee-b08f-4e2d-d8fbb496adfd@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 May 2017 16:04:00 -0700
Message-ID: <CAPcyv4hGL8ZXfsnN4jossEr2VEFSA7iBaAnx94czryBy7cDahQ@mail.gmail.com>
Subject: Re: Fw: Panic when make check for ndctl
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
To: Yasunori Goto <ygotopersonal@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 29, 2017 at 7:21 AM, Yasunori Goto <ygotopersonal@gmail.com> wrote:
>
> Hello,
> I tried "make check" of ndctl command on the kernel of libnvdimm-for-next
> branch(*),
> but I feel its kernel is unstable when nfit_test.ko module is loaded.
>
> (*)  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
> libnvdimm-for-next
>         The newest commit is f5705aa8cfed
>
> Here is console logs when the kernel was paniced, and I'll attach the kernel
> config file.
>
> Does anyone know how to solve this? Am I something wrong?

No, you're not doing anything wrong. This is a known issue that I am
investigating. The reports of this usually come from distributions
with older module loading infrastructure. If you can try with a recent
Fedora that would mimic the environment I normally use to test, but
hopefully in the next week or so I'll root cause what is triggering
this on CentOS and Debian.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
