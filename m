MIME-Version: 1.0
In-Reply-To: <20160311232941.GA139754@tevye.fc.hp.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
	<833a627a8cff27a72f946fa9432cacf2a855e485.1457730736.git.jerry.hoemann@hpe.com>
	<CAPcyv4gBg5g2Zj6xE0RC0k68t+x8KY9zaJprRC4UYP3HAX3oew@mail.gmail.com>
	<20160311232941.GA139754@tevye.fc.hp.com>
Date: Sat, 12 Mar 2016 08:49:44 -0700
Message-ID: <CADDOmiKotO4d81STbf1dL033HRqmiWYQ_HHHDGeU_jyYSJMdWA@mail.gmail.com>
Subject: Re: [RFC v6 2/8] nvdimm: Add wrapper for IOCTL pass thru
From: Vishal Verma <vishal@kernel.org>
Content-Type: text/plain; charset=UTF-8
To: Jerry.Hoemann@hpe.com
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 11, 2016 at 4:29 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>>                                        Also let's drop the ncp_ prefix,
>> it's non-idiomatic with the rest of the definitions in this file.
>
>
> I like field names with prefixes that refer back to the structure they're
> defined in.  It makes reading code easier.  (e.g. how many times is
> "size" defined in a struct?)
>
> would you be okay with a prefix "nd_"?  it doesn't quite tie as closely
> to the struct, but it should make them unique w/in the kernel.

Isn't this leaning towards the "Hungarian notation", and isn't that
discouraged in the kernel coding style..

>From Documentation/CodingStyle

Encoding the type of a function into the name (so-called Hungarian
notation) is brain damaged - the compiler knows the types anyway and can
check those, and it only confuses the programmer.
