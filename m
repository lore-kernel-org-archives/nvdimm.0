Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A291A1A1F3C
 for <linux-nvdimm@lists.01.org>; Sat, 12 Mar 2016 09:51:04 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id r187so107358342oih.3
 for <linux-nvdimm@lists.01.org>; Sat, 12 Mar 2016 09:50:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADDOmiKotO4d81STbf1dL033HRqmiWYQ_HHHDGeU_jyYSJMdWA@mail.gmail.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
 <833a627a8cff27a72f946fa9432cacf2a855e485.1457730736.git.jerry.hoemann@hpe.com>
 <CAPcyv4gBg5g2Zj6xE0RC0k68t+x8KY9zaJprRC4UYP3HAX3oew@mail.gmail.com>
 <20160311232941.GA139754@tevye.fc.hp.com>
 <CADDOmiKotO4d81STbf1dL033HRqmiWYQ_HHHDGeU_jyYSJMdWA@mail.gmail.com>
Date: Sat, 12 Mar 2016 09:50:47 -0800
Message-ID: <CAPcyv4itG0tyBLW7G1babYVd8UDyTG2Vg8xbwddz6n0z02LYdw@mail.gmail.com>
Subject: Re: [RFC v6 2/8] nvdimm: Add wrapper for IOCTL pass thru
From: Dan Williams <dan.j.williams@intel.com>
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
To: Vishal Verma <vishal@kernel.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Mar 12, 2016 at 7:49 AM, Vishal Verma <vishal@kernel.org> wrote:
> On Fri, Mar 11, 2016 at 4:29 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>>>                                        Also let's drop the ncp_ prefix,
>>> it's non-idiomatic with the rest of the definitions in this file.
>>
>>
>> I like field names with prefixes that refer back to the structure they're
>> defined in.  It makes reading code easier.  (e.g. how many times is
>> "size" defined in a struct?)
>>
>> would you be okay with a prefix "nd_"?  it doesn't quite tie as closely
>> to the struct, but it should make them unique w/in the kernel.
>
> Isn't this leaning towards the "Hungarian notation", and isn't that
> discouraged in the kernel coding style..
>
> From Documentation/CodingStyle
>
> Encoding the type of a function into the name (so-called Hungarian
> notation) is brain damaged - the compiler knows the types anyway and can
> check those, and it only confuses the programmer.

I wouldn't go that far... look at "struct bio", "struct file", or
"struct nd_region" that have a common prefix for (some) member fields.
That's not Hungarian notation, that's making the code easier to grep.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
