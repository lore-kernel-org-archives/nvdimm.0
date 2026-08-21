Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C12B47B43E;
	Fri, 21 Aug 2026 11:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787312421; cv=none; b=dyoeHVJYokqdXIh/yX0ozOquSFFdDJHVCK7FxvYymV/yrLKgrlC1ljL/RlO+29vKDUGJsIWw3AmWVm/wS+xS+vH12rReNUiG9yxcT07lbCpPhRPMeDKsWWfYRjNuauuhBNyLZEJtg9yOip1w3EhlmzBJlR4PnrLkdAoKffNERLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787312421; c=relaxed/simple;
	bh=NW5ezp3UBYABHtSn57DxiJAJdWRS69ouWi3NcX9rwNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cwS9oDeWsumg6a75fR5m1gyczA8K6EV0X6LyPkJ1+A/dpi6dZvAIks9sWnOObNOhPqD+/84WxbrVfIN0YdSlOSyvukt443w30pvmG7/LLqHm5XAYVUdEGI41kl1C1Ts2B0nY/+1wVQd22Ox0VHkVIu+7kl10O7UfZzXZdq8aCZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfv+6/SH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfv+6/SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19C21F000E9;
	Fri, 21 Aug 2026 11:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787312416;
	bh=QAry0w+4LHlbiY3u257K5+LjrU2QJaSc/mnEH8VEnQs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cfv+6/SHLgM5qih8qOzllcJRt9Q26jrCJSsXbtLBbIjUBLEVj3khW15HMTlmqsQ0d
	 09EdR+Y1sSjhKFhi1DqmfqqL8E7evD061TL+CA8szxr2klOOc7N10ZXOdXbJXLwNIb
	 pG6fgPgkYJJnBMHPikLU7qTdHSPo73xnZspDF6mLUZ6dbk5oPGC5z0BGaPROksC5Zj
	 1oxO+61KMkF+r8lr5u7vM6FtWSNv1IYKGaRE5MjHCt83zZxzg3C3aEr6oHapS/5zWt
	 cexfwvw4uZMz8mHJQ+scBbnEYdaBabRe/ZUEm+wZJqHPL/Lu8qeMrfb7xH5Tm71N7e
	 bElRFlcb3DnZw==
Message-ID: <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
Date: Fri, 21 Aug 2026 13:39:59 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
To: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, John Groves <john@jagalactic.com>,
 John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>,
 Bernd Schubert <bschubert@ddn.com>,
 Alison Schofield <alison.schofield@intel.com>,
 John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
 Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <jic23@kernel.org>,
 Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong
 <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>,
 Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>,
 Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>,
 Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 Gregory Price <gourry@gourry.net>, Andrew Morton
 <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Jiri Slaby <jirislaby@kernel.org>,
 Ethan Nelson-Moore <enelsonmoore@gmail.com>,
 Gabriel Whigham <gabewhigham@gmail.com>, Aravind Ramesh
 <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/11/26 11:24, Christian Brauner wrote:
> On Tue, Aug 11, 2026 at 10:59:50AM +0200, Miklos Szeredi wrote:
>> On Thu, 6 Aug 2026 at 06:37, Darrick J. Wong <djwong@kernel.org> wrote:
>>
>>> IOWs, let's fix the remaining wobbles (if any) and just merge this
>>> already.  No more side quests through gigantic refactorings of fusex,
>>> that's too much to ask after you already redesigned and reimplemented
>>> the whole thing already.
>>
>> Without any intention to change the direction, let me just state some facts:
>>
>>  - it was never suggested that famfs depend on the fusex work in any way
>>
>>  - the plan to add famfs mappings to fuse was laid out two and a half
>> years ago in reply to the very first rfc posting and has basically
>> remained unchanged since then:
>>
>> https://lore.kernel.org/all/CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com/
>>
>> I understand how that seemingly simple API addition was overwhelming
>> for John, and I should have been more proactive in helping with the
>> implementation.  That's entirely my fault.
>>
>> On the other hand John could have been more trusting that the plan will work.
>>
>> But that's behind us now, let's move on...
> 
> with fuse, please...

Okay, we're now (again? :) ) in a difficult situation where some people support
standalone famfs, while other people (including Christian) prefer a fuse version.

The history on the fuse approach hasn't exactly been a role model (bpf is where
things really went wrong), so I understand the pushback from John. At the same
time, I also read that the earlier fuse problems might now have been solved and
that there were many misunderstandings.

Reading the arguments from both sides, I think we're missing a common
understanding when it comes to the fuse-based approach of:

(a) Whether a fuse-based approach is feasible.

    Are there any major blockers remaining?

(b) Whether a fuse-based approach is inefficient.

    Are there scenarios remaining where performance or metadata overhead would
    be bad without an easy way to improve the situation?

(c) Whether a fuse-based approach is a bad conceptual fit.

    Will fuse have to carry a lot of famfs special sauce that cannot
    really be used elsewhere / generalized?

(d) Whether a fuse-based approach is too invasive.

    Will fuse extensions to support famfs actually make it harder to maintain or
    slower on some paths?

(e) Whether a fuse-based approach will make famfs harder to extend.

    Is there known follow-up work that will be hard/impossible to model in fuse?

(f) Whether a fuse-based approach will reduce maintenance effort.

    Will maintaining fuse extensions possibly be harder than maintaining
    standalone famfs?

(g) Whether a fuse-based approach would make famfs more complex.

    Will the shift to user space result in a significantly more complicated
    overall solution that must be maintained?

(h) Who would help drive the fuse approach?

    Fuse people seem to be willing to help, but I expect that there must be a
    close cooperation with John to make this fly. I don't expect that John
    himself can easily (or understandably wants to :) ) do the heavy fuse
    lifting.

(i) Who would maintain any famfs fuse extensions and own any bugs?

    famfs will possibly depend on fuse extensions that might initially only be
    used by famfs. Would the fuse maintainers just naturally deal with that?

(j) Whether a fuse-based approach has an end in sight.

    famfs goes back .... quite a long time. It would be nice to close that
    chapter :)

    Is there an end in sight, or could we end up in the same situation in 6m/1y/
    ...

    IOW, is there a way to agree on an MVP that won't require a lot of further
    re-planning and changes to a fuse-based design?


In the past there were plenty of misunderstandings. People can continue figuring
this out on the list, not sure how well that will go :)

I know that John had calls with fuse folks in the past. Maybe it makes sense for
all parties (including all relevant maintainers) to have a focused meeting where
they can go through the points raised above and try to get a common understanding?

Sure, opinions will still differ, but I'd hope that we can at least try to
minimize misunderstandings.

I don't have a strong opinion on either approach, I think the most important
part is to find a way forward that will get famfs over the finishing line.

-- 
Cheers,

David
