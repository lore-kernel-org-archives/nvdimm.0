Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB62221E7492E
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 15:07:36 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id v188so66399oia.5
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 15:10:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1505858348.3864.8.camel@hpe.com>
References: <150585068899.18066.14107564726083870194.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150585069444.18066.1329567407748978657.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1505858348.3864.8.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Sep 2017 15:10:40 -0700
Message-ID: <CAPcyv4jf4fdZvUOmC+0RcP_Py-2TNtBLLX3q3GxrqCv7+yvQ=Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] libnvdimm, namespace: fix btt claim class crash
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
To: "Saldivar, Maurice A." <maurice.a.saldivar@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 19, 2017 at 3:06 PM, Saldivar, Maurice A.
<maurice.a.saldivar@hpe.com> wrote:
> I applied this and the kernel patch and was successfully able to
> configure an NVDIMM-N into sector mode. I do have a question about
> specific behavior I observed. Before I was able to configure an NVDIMM
> into any mode from any mode. With these patchs if I go to sector mode
> and try going to memory or dax mode it fails with:
>
> # ndctl create-namespace -f -e namespace0.0 -m memory
>   Error: namespace0.0: sector_size: 4096 not supported
> failed to reconfigure namespace: Invalid argument
>
> but if I go sector->raw-><mode> I can get into other modes fine. Was
> this the intended behavior?
>

Nope, that's another bug. I'll fix that up.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
