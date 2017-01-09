Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 559E98178D
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 14:00:30 -0800 (PST)
Received: by mail-oi0-x234.google.com with SMTP id u143so116240362oif.3
 for <linux-nvdimm@lists.01.org>; Mon, 09 Jan 2017 14:00:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170109215636.GA5330@omniknight.lm.intel.com>
References: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170109215636.GA5330@omniknight.lm.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 9 Jan 2017 14:00:29 -0800
Message-ID: <CAPcyv4gUcb-Swm2t8yySq67BYBkoufBLE+vunionOLx2Rt_Oaw@mail.gmail.com>
Subject: Re: [ndctl PATCH 0/7] introduce 'daxctl list',
 and 'ndctl list' updates
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 9, 2017 at 1:56 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> On 01/06, Dan Williams wrote:
>> * The 'ndctl list' command awkwardly prints out all the corresponding
>>   device-dax information when a namespace is in 'dax' mode. Conversely if
>>   someone is only interested in listing device-dax information they need to
>>   contend with libnvdimm data.
>>
>>   Introduce a separate daxctl utility with its own 'list' command for this
>>   purpose, and make the listing of device-dax data through 'ndctl list'
>>   optional (new --device-dax option).
>
> the 'rpmbuild' script was failing as the new daxctl utility wasn't
> included in %files in the spec. The following patch fixes that.
>
> 8<-----
>
> From d26a582b4ae9e69a22e52908a5d4bbae0a79717f Mon Sep 17 00:00:00 2001
> From: Vishal Verma <vishal.l.verma@intel.com>
> Date: Mon, 9 Jan 2017 14:52:34 -0700
> Subject: [PATCH] spec: add the new daxctl binary to the spec file
>
> The missing binary was triggering the "installed but unpackaged file
> found" check for rpmbuild. Add daxctl to the %files section as we do
> want it to be packaged.

Yes, we do want it packaged, but in it's own rpm. I have patch to add
that as well as a daxctl man page.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
