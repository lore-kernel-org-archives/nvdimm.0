From: Socer Liu <soccer_liu-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: ND_MIN_NAMESPACE_SIZE
Date: Sat, 1 Jul 2017 12:08:55 -0700
Message-ID: <DAEBDB4D-788F-4082-8B6D-EBDC54870450@yahoo.com>
References: <1158028069.2624087.1498868468565.ref@mail.yahoo.com>
 <1158028069.2624087.1498868468565@mail.yahoo.com>
 <CAPcyv4hiWY-6Bdf=U1QR+bCVvPy8Fq+eaL0+-qzLvbpcEuwn4A@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hiWY-6Bdf=U1QR+bCVvPy8Fq+eaL0+-qzLvbpcEuwn4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Here is our usage case:

We are trying to represent each Docker container image layer in a read-only persist memory device before injecting into a guest Linux VM for constructing a union file system as part of the container execution preparation task.
 Those read-only persistent memory devices are RAM emulated, not the real PMEM devices. Their sizes are very flexible. On top of that, the sizes of those docker layers could be well below 4MB. Looking at the nvdimm code, NV_MIN_NAMESPACE does not seem to be used in any other context other than the initial size checking. So I built a private kernel with a redefined NV_MIN_NAMESPACE_SIZE to much smaller number, such 64kb, and the persistent memory devices for smaller layers start functioning as expected.


Thanks 
Cheng-mean




> On Jun 30, 2017, at 6:53 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> 4M was picked as the smallest "reasonable" size for a disk. We could
> make it smaller, but what is the use case?
> 
>> On Fri, Jun 30, 2017 at 5:21 PM, Soccer Liu <soccer_liu-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
>> Hi all:
>> I noticed that ND_MIN_NAMESPACE_SIZE is defined as 4MB.
>> nvdimm_namespace_common_probe(..){..
>>   if (size < ND_MIN_NAMESPACE_SIZE) {
>> dev_dbg(&ndns->dev, "%pa, too small must be at least %#x\n",
>> &size, ND_MIN_NAMESPACE_SIZE);
>> return ERR_PTR(-ENODEV);
>> }...}
>> In our configuration, we have a host based software enumerated PMEM device that could be much smaller than 4MB.Because of above failure, no PMEM device was exposed.
>> I changed ND_MIN_NAMESPACE_SIZE to smaller size (such as 256 KB) and a smaller size (<4MB) Persistent Memory starts working.Is there any reason that it cannot be smaller?
>> Thanks
>> Cheng-mean
>> _______________________________________________
>> Linux-nvdimm mailing list
>> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
>> https://lists.01.org/mailman/listinfo/linux-nvdimm
