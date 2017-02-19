Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x22d.google.com (mail-wm0-x22d.google.com
 [IPv6:2a00:1450:400c:c09::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B8074821B9
 for <linux-nvdimm@lists.01.org>; Sun, 19 Feb 2017 08:28:35 -0800 (PST)
Received: by mail-wm0-x22d.google.com with SMTP id v77so37599026wmv.0
 for <linux-nvdimm@lists.01.org>; Sun, 19 Feb 2017 08:28:35 -0800 (PST)
Subject: Re: [PATCH 1/3] Allow all supported HPE DSM functions to be called
References: <cover.1486750246.git.linda.knippers@hpe.com>
 <5d86cd3620ca9eb3cda38cce0401b2984526cad7.1486750247.git.linda.knippers@hpe.com>
 <CAPcyv4gRNeuQFwDtwGzBbs+CKZnkYibCMm0UXCD2ZWyOZN0GJg@mail.gmail.com>
 <58A1F84A.2090605@hpe.com>
 <CAPcyv4iW8Kwvm9dFgM7se6kQ7ZOXqX89hz7=FhOrpAbcCEcgAQ@mail.gmail.com>
 <58A4E20F.8040302@hpe.com>
 <CAPcyv4iog-kV3-Bu2KYzC7hxkAO82mbUfY-nyYdEXReJC8nioQ@mail.gmail.com>
 <58A4F63D.70908@hpe.com>
 <CAPcyv4i8GSU13GZBta+YH0NfVcDztLy2SjfNJmtdpjs+7igULQ@mail.gmail.com>
 <56cd91c8-a5d8-7339-2ff2-f2e706691c8b@hpe.com>
 <CAPcyv4ggMwddnkHxAkLkSHLpM6h6t3zJQ3mr2P4t+6xPZx0dxw@mail.gmail.com>
From: Boaz Harrosh <boaz@plexistor.com>
Message-ID: <e1ea915d-4881-95e9-9f92-bce8f07eeb8c@plexistor.com>
Date: Sun, 19 Feb 2017 18:28:31 +0200
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ggMwddnkHxAkLkSHLpM6h6t3zJQ3mr2P4t+6xPZx0dxw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 02/16/2017 09:35 PM, Dan Williams wrote:
> On Thu, Feb 16, 2017 at 10:51 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
<>
>> True, but configuring boot options and a reboot are required.
> 
> Module options are specified at module load time so you don't
> necessarily need a reboot. However, I'm now of the opinion that
> allowing the family to be changed is a more complete solution to both
> problems.
<>
> 
> Let's do the work to allow the family to be switched so that tooling
> can override the kernel default, because it does seem valid for a DIMM
> to support multiple DSM-family types and that gives more than one path
> to use a vendor specific passthrough.

BTW:
Any module-parameter is already accessible via sysfs. And can be made
writeable. If you need to run a small function on modification, that
is easy enough, just as any sysfs, give the parameter a function-pointer.

Even if you do an hot event, I'd rather it be as a module-parameter,
because of the already established path in sysfs.

Just my $0.017
Boaz

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
