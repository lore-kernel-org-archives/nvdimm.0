Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20170724154849.GQ652@quack2.suse.cz>
References: <20170721155848.GO18014@stefanha-x1.localdomain>
 <CAPcyv4gtWYpzbmggsbdLocPiMzU2rVt-ee+kL24gbrPxKd5Eyw@mail.gmail.com>
 <1500818683.4073.31.camel@redhat.com>
 <CAPcyv4h5O4D2kp6SJhWiz4V=dOLDa_Q3pk2B=u-x7hKKQqdXsQ@mail.gmail.com>
 <1500833428.4073.36.camel@redhat.com>
 <CAPcyv4hpbk0jgp+mA=q05zVBV8ZSZvCvV68JJ4gjE3QhK70d1w@mail.gmail.com>
 <20170724102330.GE652@quack2.suse.cz>
 <1157879323.33809400.1500897967669.JavaMail.zimbra@redhat.com>
 <20170724123752.GN652@quack2.suse.cz>
 <CAPcyv4g-X8S95=uQBo5MzxpwKfqdTbmBis3B56i59wqWiPnCBA@mail.gmail.com>
 <20170724154849.GQ652@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 24 Jul 2017 09:19:00 -0700
Message-ID: <CAPcyv4iLdcQhDJhi1sh8DT9yW5qSh5ruq-x=bsVTbgzO_NNT4w@mail.gmail.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
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
To: Jan Kara <jack@suse.cz>
Cc: Kevin Wolf <kwolf@redhat.com>, Pankaj Gupta <pagupta@redhat.com>, Rik van Riel <riel@redhat.com>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@gmail.com>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 24, 2017 at 8:48 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 24-07-17 08:10:05, Dan Williams wrote:
>> On Mon, Jul 24, 2017 at 5:37 AM, Jan Kara <jack@suse.cz> wrote:
[..]
>> This approach would turn into a full fsync on the host. The question
>> in my mind is whether there is any optimization to be had by trapping
>> dax_flush() and calling msync() on host ranges, but Jan is right
>> trapping blkdev_issue_flush() and turning around and calling host
>> fsync() is the most straightforward approach that does not need driver
>> interface changes. The dax_flush() approach would need to modify it
>> into a async completion interface.
>
> If the backing device on the host is actually a normal block device or an
> image file, doing full fsync() is the most efficient implementation
> anyway...

Ah, ok, great. That was the gap in my understanding.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
