Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54FD81C7.3080000@plexistor.com>
References: <54F82CE0.4040502@plexistor.com>
	<54F82ED1.8030900@plexistor.com>
	<CAPcyv4i5WfR48hmGwqLDgTFRpUPaAxusHXKKUKY4FBxu1Mqm+w@mail.gmail.com>
	<54FD81C7.3080000@plexistor.com>
Date: Mon, 9 Mar 2015 10:44:09 -0400
Message-ID: <CAPcyv4hOgsTHF53ospPdDyN6G6L0C_1NVC6xEVm_mRjocULyJQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 9, 2015 at 7:19 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> On 03/05/2015 10:56 PM, Dan Williams wrote:
[..]
>> It's not "politics".  Setting standards takes time and the platforms
>> in question simply jumped the gun to enable a proof-of-concept.
>>
>
> So ye, but once you have 100,000 devices out there, then the dichotomy
> between standards-takes-time vs proof-of-concept, becomes politics.

Ok.

...although, I have a question about this "100,000 devices" you quote.
What's not clear to me is how many platforms are shipping with
type-12.  Certainly there are very many NVDIMMs on the market, but
which off-the-shelf systems can one obtain that include type-12
support?  Not that it would change the disposition of this patch, if
platforms are in the field they're "in the field!", just clarifying
that "100,000 devices" is NVDIMMs not type-12 platforms, right?
