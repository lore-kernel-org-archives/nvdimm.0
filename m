Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 33CC3210FB9E7
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 12:39:39 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 1/2] acpi/nfit: Update nfit driver to comply with ACPI
 6.1
Date: Mon, 18 Jun 2018 19:39:35 +0000
Message-ID: <1529350667.14039.119.camel@hpe.com>
References: <1461620099-11933-1-git-send-email-toshi.kani@hpe.com>
 <1461620099-11933-2-git-send-email-toshi.kani@hpe.com>
 <CAA9_cmenbY9GStibRjO0BfTq0kzzzqThiLeOygJsT9L03BFsBQ@mail.gmail.com>
In-Reply-To: <CAA9_cmenbY9GStibRjO0BfTq0kzzzqThiLeOygJsT9L03BFsBQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <DA7E9EEEE7D0534C854733E9A6DF8D30@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "robert.moore@intel.com" <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-06-18 at 12:01 -0700, Dan Williams wrote:
> On Mon, Apr 25, 2016 at 2:43 PM Toshi Kani <toshi.kani@hpe.com> wrote:
> > 
> > ACPI 6.1, Table 5-133, updates NVDIMM Control Region Structure
> > as follows.
> >  - Valid Fields, Manufacturing Location, and Manufacturing Date
> >    are added from reserved range.  No change in the structure size.
> >  - IDs (SPD values) are stored as arrays of bytes (i.e. big-endian
> >    format).  The spec clarifies that they need to be represented
> >    as arrays of bytes as well.
> > 
> 
> Circling back on this a couple years too late... where are you reading
> this "arrays of bytes" note. As far as I can see this is wrong. JEDEC
> says that vendor id is stored LSB of the id is stored at the lowest
> byte in SPD, which is little endian. So it seems Linux has showing the
> incorrect value for a long time now.

This follows ACPI 6.2a section 5.2.25.10 NVDIMM Representation Format,
which Robert cited in his comment below:
https://patchwork.kernel.org/patch/10237609/

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
