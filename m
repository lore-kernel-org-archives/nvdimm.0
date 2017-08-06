Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FCC0208F7AC1
 for <linux-nvdimm@lists.01.org>; Sat,  5 Aug 2017 20:25:56 -0700 (PDT)
Received: by mail-pf0-x241.google.com with SMTP id p13so5690660pfd.4
 for <linux-nvdimm@lists.01.org>; Sat, 05 Aug 2017 20:28:10 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC 01/16] NOVA: Documentation
From: Steven Swanson <steven.swanson@gmail.com>
In-Reply-To: <1501859388.2757.1.camel@wdc.com>
Date: Sat, 5 Aug 2017 20:28:08 -0700
Message-Id: <873FD9AB-8E7B-495B-A74C-D2AAA4305432@gmail.com>
References: <150174646416.104003.14042713459553361884.stgit@hn>
 <150174649708.104003.4595004262958377346.stgit@hn>
 <1501859388.2757.1.camel@wdc.com>
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
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

There is nothing impossible COW for mapped files, but it is not a good match for the expected usage model for DAX.  

The idea is that programs can mmap files and the build interesting data structures in them, just like they do in DRAM.  This means lots of small updatEs, and that would be very slow if each of them required a COW.

The reason we use COW for normal accesses is to provide atomicity.  Programs will probably want doe form of atomicity for their mmaped data structures, but part of the DAX bargain is that programmer are responsible for this rather than the FS.

-steve

--
Composed on (and maybe dictated to) my phone.

> On Aug 4, 2017, at 08:09, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
>> On Thu, 2017-08-03 at 00:48 -0700, Steven Swanson wrote:
>> +### DAX Support
>> +
>> +Supporting DAX efficiently is a core feature of NOVA and one of the challenges
>> +in designing NOVA is reconciling DAX support which aims to avoid file system
>> +intervention when file data changes, and other features that require such
>> +intervention.
>> +
>> +NOVA's philosophy with respect to DAX is that when a program uses DAX mmap to
>> +to modify a file, the program must take full responsibility for that data and
>> +NOVA must ensure that the memory will behave as expected.  At other times, the
>> +file system provides protection.  This approach has several implications:
>> +
>> +1. Implementing `msync()` in user space works fine.
>> +
>> +2. While a file is mmap'd, it is not protected by NOVA's RAID-style parity
>> +mechanism, because protecting it would be too expensive.  When the file is
>> +unmapped and/or during file system recovery, protection is restored.
>> +
>> +3. The snapshot mechanism must be careful about the order in which in adds
>> +pages to the file's snapshot image.
> 
> Hello Steven,
> 
> Thank you for having shared this very interesting work. After having read the
> NOVA paper and patch 01/16 I have a question for you. Does the above mean that
> COW is disabled for writable mmap-ed files? If so, what is the reason behind
> this? Is there a fundamental issue that does not allow to implement COW for
> writable mmap-ed files? Or have you perhaps tried to implement this and was the
> performance not sufficient? Please note that I'm neither a filesystem nor a
> persistent memory expert.
> 
> Thanks,
> 
> Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
