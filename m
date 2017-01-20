Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20170120094750.GE14115@quack2.suse.cz>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <20170117063355.GL14033@birch.djwong.org>
 <20170117213549.GB4880@omniknight.lm.intel.com>
 <CAOvWMLYMR-VvAVNuVjXPC-woxY6afQX5-hMC=Vj2p=3AGj9tyA@mail.gmail.com>
 <20170117223705.GD4880@omniknight.lm.intel.com>
 <20170118093801.GA24789@quack2.suse.cz>
 <20170119211719.GG4880@omniknight.lm.intel.com>
 <20170120094750.GE14115@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Jan 2017 07:42:09 -0800
Message-ID: <CAA9_cmcH1AZmNr=cg-CMH1CiJDvZkqtm+eyiuJJiu+yRzY3PDg@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Badblocks checking/representation in
 filesystems
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
Cc: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Andiry Xu <andiry@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 20, 2017 at 1:47 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 19-01-17 14:17:19, Vishal Verma wrote:
>> On 01/18, Jan Kara wrote:
>> > On Tue 17-01-17 15:37:05, Vishal Verma wrote:
>> > 2) PMEM is exposed for DAX aware filesystem. This seems to be what you are
>> > mostly interested in. We could possibly do something more efficient than
>> > what NVDIMM driver does however the complexity would be relatively high and
>> > frankly I'm far from convinced this is really worth it. If there are so
>> > many badblocks this would matter, the HW has IMHO bigger problems than
>> > performance.
>>
>> Correct, and Dave was of the opinion that once at least XFS has reverse
>> mapping support (which it does now), adding badblocks information to
>> that should not be a hard lift, and should be a better solution. I
>> suppose should try to benchmark how much of a penalty the current badblock
>> checking in the NVVDIMM driver imposes. The penalty is not because there
>> may be a large number of badblocks, but just due to the fact that we
>> have to do this check for every IO, in fact, every 'bvec' in a bio.
>
> Well, letting filesystem know is certainly good from error reporting quality
> POV. I guess I'll leave it upto XFS guys to tell whether they can be more
> efficient in checking whether current IO overlaps with any of given bad
> blocks.
>
>> > Now my question: Why do we bother with badblocks at all? In cases 1) and 2)
>> > if the platform can recover from MCE, we can just always access persistent
>> > memory using memcpy_mcsafe(), if that fails, return -EIO. Actually that
>> > seems to already happen so we just need to make sure all places handle
>> > returned errors properly (e.g. fs/dax.c does not seem to) and we are done.
>> > No need for bad blocks list at all, no slow down unless we hit a bad cell
>> > and in that case who cares about performance when the data is gone...
>>
>> Even when we have MCE recovery, we cannot do away with the badblocks
>> list:
>> 1. My understanding is that the hardware's ability to do MCE recovery is
>> limited/best-effort, and is not guaranteed. There can be circumstances
>> that cause a "Processor Context Corrupt" state, which is unrecoverable.
>
> Well, then they have to work on improving the hardware. Because having HW
> that just sometimes gets stuck instead of reporting bad storage is simply
> not acceptable. And no matter how hard you try you cannot avoid MCEs from
> OS when accessing persistent memory so OS just has no way to avoid that
> risk.
>
>> 2. We still need to maintain a badblocks list so that we know what
>> blocks need to be cleared (via the ACPI method) on writes.
>
> Well, why cannot we just do the write, see whether we got CMCI and if yes,
> clear the error via the ACPI method?

I would need to check if you get the address reported in the CMCI, but
it would only fire if the write triggered a read-modify-write cycle. I
suspect most copies to pmem, through something like
arch_memcpy_to_pmem(), are not triggering any reads. It also triggers
asynchronously, so what data do you write after clearing the error?
There may have been more writes while the CMCI was being delivered.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
