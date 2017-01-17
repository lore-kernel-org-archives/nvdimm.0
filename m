From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next 0112 tree breaks fs DAX
Date: Tue, 17 Jan 2017 13:25:07 -0700
Message-ID: <b95fcdd4-9537-9b4c-e821-4043f1a944ad@intel.com>
References: <20170113101641.3jecr5qx2pgajc2k@XZHOUW.usersys.redhat.com>
 <20170116092916.lltpfa24gzlj3hkr@XZHOUW.usersys.redhat.com>
 <20170116214543.1388c2e9@canb.auug.org.au>
 <833df5ca-39a5-f402-fcd1-985217a55a85@intel.com>
 <711fc876-c805-8483-a6af-f4e3c8369084@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <711fc876-c805-8483-a6af-f4e3c8369084-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, "Zwisler, Ross" <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On 01/17/2017 11:13 AM, Dave Jiang wrote:
> 
> 
> On 01/17/2017 09:05 AM, Dave Jiang wrote:
>> On 01/16/2017 03:45 AM, Stephen Rothwell wrote:
>>> Hi Xiong,
>>>
>>> Just cc'ing Andrew.
>>>
>>> On Mon, 16 Jan 2017 17:29:16 +0800 Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>>
>>>> On Fri, Jan 13, 2017 at 06:16:41PM +0800, Xiong Zhou wrote:
>>>>> Hi,
>>>>>
>>>>> These cases "hang" when testing with -o dax mount option:
>>>>> xfstests generic/030 generic/34{0,4,5,6} generic/198
>>>>> (maybe more)
>>>>>
>>>>> The test programme holetest or aiodio keep running for a
>>>>> long time. It's killable, but it seems never return.
>>>>>
>>>>> With both ext4 and xfs as fs.
>>>>>
>>>>> Without -o dax mount option, cases pass in seconds.
>>>>>
>>>>> 0111 tree passed the tests.
>>>>>
>>>>> sh-4.2# git log --oneline next-20170111..next-20170112 fs/dax.c
>>>>> 0c9a7909dd13 mm, dax: change pmd_fault() to take only vmf parameter
>>>>> f8dbc198d4ea mm, dax: make pmd_fault() and friends be the same as fault()  
>>>>
>>>> 0112 tree with above 2 commits reverted pass the tests.
>>>
>>
>> Thanks. I will debug.
>>
> 
> Xiong,
> I think I reproduced the issue, but only on the second commit
> 0c9a7909dd13 and not the first one f8dbc198d4ea. Can you please confirm
> that "f8dbc198d4ea mm, dax: make pmd_fault() and friends be the same as
> fault()" is ok or the failure starts with that? Thanks!

Actually nevermind. I am able to reproduce on the first commit now. Thanks.
